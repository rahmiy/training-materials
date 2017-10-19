/* This is an extract from THOR's anomaly detection rule set */

/*
   Yara Rule Set
   Author: Florian Roth
   Date: 2017-08-11
   Identifier: PowerShell Anomalies
   Reference: https://twitter.com/danielhbohannon/status/905096106924761088
*/

rule PowerShell_Case_Anomaly {
   meta:
      description = "Detects obfuscated PowerShell hacktools"
      author = "Florian Roth"
      reference = "https://twitter.com/danielhbohannon/status/905096106924761088"
      date = "2017-08-11"
      score = 70
   strings:
      // first detect 'powershell' keyword case insensitive
      $s1 = "powershell" fullword nocase ascii wide
      // define the normal cases
      $sr1 = /(powershell|Powershell|PowerShell|POWERSHELL|powerShell)/ fullword ascii wide
      // define the normal cases
      $sn1 = "powershell" fullword ascii wide
      $sn2 = "Powershell" fullword ascii wide
      $sn3 = "PowerShell" fullword ascii wide
      $sn4 = "POWERSHELL" fullword ascii wide

      // adding a keyword with a sufficent length and relevancy
      $k1 = "-noprofile" fullword nocase ascii wide
      // define normal cases
      $kn1 = "-noprofile" ascii wide
      $kn2 = "-NoProfile" ascii wide
      $kn3 = "-noProfile" ascii wide
      $kn4 = "-NOPROFILE" ascii wide
   condition:
      filesize < 800KB and
      // find all 'powershell' occurances and ignore the expected cases
      ( #s1 < 3 and #s1 > #sr1 ) or
      ( $s1 and not 1 of ($sn*) ) or
      // find all '-norpofile' occurances and ignore the expected cases
      ( $k1 and not 1 of ($kn*) )
}

rule WScriptShell_Case_Anomaly {
   meta:
      description = "Detects obfuscated wscript.shell commands"
      author = "Florian Roth"
      reference = "Internal Research"
      date = "2017-09-11"
      score = 60
   strings:
      // first detect powershell keyword case insensitive
      $s1 = "WScript.Shell\").Run" nocase ascii wide
      // define the normal cases
      $sn1 = "WScript.Shell\").Run" ascii wide
      $sn2 = "wscript.shell\").run" ascii wide
      $sn3 = "WSCRIPT.SHELL\").RUN" ascii wide
      $sn4 = "Wscript.Shell\").Run" ascii wide
   condition:
      filesize < 800KB and
      ( $s1 and not 1 of ($sn*) )
}