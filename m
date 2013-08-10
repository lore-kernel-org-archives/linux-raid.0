From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Subject: Re: Recovering from two almost simultaneously failed devices in RAID1
Date: Sat, 10 Aug 2013 20:05:42 +0200
Message-ID: <520680F6.1090108@aei.mpg.de>
References: <52066A7A.5050007@aei.mpg.de> <52066B43.1010901@aei.mpg.de> <52067ADB.8080100@aei.mpg.de> <CADNH=7G=MFJuwrTQ=r4uFgTji87iVr3ou04q7yN50tCojJGKfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080700000802020106030705"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7G=MFJuwrTQ=r4uFgTji87iVr3ou04q7yN50tCojJGKfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms080700000802020106030705
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

On 08/10/2013 07:45 PM, Mathias Bur=C3=A9n wrote:
> smartctl -a=20

Looks pretty much innocent:

  1 Raw_Read_Error_Rate     0x000a   100   100   000    Old_age   Always
      -       0
  2 Throughput_Performance  0x0005   100   100   050    Pre-fail
Offline      -       0
  3 Spin_Up_Time            0x0007   100   100   050    Pre-fail  Always
      -       0
  5 Reallocated_Sector_Ct   0x0013   100   100   050    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x000b   100   100   050    Pre-fail  Always
      -       0
  8 Seek_Time_Performance   0x0005   100   100   050    Pre-fail
Offline      -       0
  9 Power_On_Hours          0x0012   100   100   000    Old_age   Always
      -       9098
 10 Spin_Retry_Count        0x0013   100   100   050    Pre-fail  Always
      -       0
 12 Power_Cycle_Count       0x0012   100   100   000    Old_age   Always
      -       13
167 Unknown_Attribute       0x0022   100   100   000    Old_age   Always
      -       0
168 Unknown_Attribute       0x0012   100   100   000    Old_age   Always
      -       2
169 Unknown_Attribute       0x0013   092   092   010    Pre-fail  Always
      -       0
173 Unknown_Attribute       0x0012   169   169   000    Old_age   Always
      -       0
175 Program_Fail_Count_Chip 0x0013   100   100   010    Pre-fail  Always
      -       0
192 Power-Off_Retract_Count 0x0012   100   100   000    Old_age   Always
      -       0
194 Temperature_Celsius     0x0023   073   073   030    Pre-fail  Always
      -       27 (Lifetime Min/Max 26/40)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
      -       0
240 Head_Flying_Hours       0x0013   100   100   050    Pre-fail  Always
      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      9098
     -


and

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000a   100   100   000    Old_age   Always
      -       0
  2 Throughput_Performance  0x0005   100   100   050    Pre-fail
Offline      -       0
  3 Spin_Up_Time            0x0007   100   100   050    Pre-fail  Always
      -       0
  5 Reallocated_Sector_Ct   0x0013   100   100   050    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x000b   100   100   050    Pre-fail  Always
      -       0
  8 Seek_Time_Performance   0x0005   100   100   050    Pre-fail
Offline      -       0
  9 Power_On_Hours          0x0012   100   100   000    Old_age   Always
      -       9098
 10 Spin_Retry_Count        0x0013   100   100   050    Pre-fail  Always
      -       0
 12 Power_Cycle_Count       0x0012   100   100   000    Old_age   Always
      -       12
167 Unknown_Attribute       0x0022   100   100   000    Old_age   Always
      -       0
168 Unknown_Attribute       0x0012   100   100   000    Old_age   Always
      -       2
169 Unknown_Attribute       0x0013   095   095   010    Pre-fail  Always
      -       0
173 Unknown_Attribute       0x0012   169   169   000    Old_age   Always
      -       0
175 Program_Fail_Count_Chip 0x0013   100   100   010    Pre-fail  Always
      -       0
192 Power-Off_Retract_Count 0x0012   100   100   000    Old_age   Always
      -       0
194 Temperature_Celsius     0x0023   070   070   030    Pre-fail  Always
      -       30 (Lifetime Min/Max 29/40)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
      -       0
240 Head_Flying_Hours       0x0013   100   100   050    Pre-fail  Always
      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      9098
     -


I think I need to check the BIOS settings and reseat all internal
connections on Monday, when I'm back in office. Also, I will contact
Supermicro if they know more about this (and perhaps a new BIOS).

More suggestions?

Cheers

carsten


--=20
Dr. Carsten Aulbert - Max Planck Institute for Gravitational Physics
Callinstrasse 38, 30167 Hannover, Germany
phone/fax: +49 511 762-17185 / -17193
https://wiki.atlas.aei.uni-hannover.de/foswiki/bin/view/ATLAS/WebHome


--------------ms080700000802020106030705
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIE8DCC
BOwwggPUoAMCAQICAk/QMA0GCSqGSIb3DQEBBQUAMDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQK
EwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0EwHhcNMTMwNTA2MTU1OTM4WhcNMTQw
NjA1MTU1OTM4WjA9MRMwEQYDVQQKEwpHZXJtYW5HcmlkMQwwCgYDVQQLEwNBRUkxGDAWBgNV
BAMTD0NhcnN0ZW4gQXVsYmVydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJzM
vu6K/4EHUx/JuCoansTOW8cSyuPbvElm7IfuuEfXHJ1/m/Lbkv/C7oA+0Pvk4WCOLBx1OVUk
4vVZ0Lq6G9ekTgeZVaqFvHXKlFdUvdp3b5/nlAGc3z7GaDG/F6LdI5Iu374cTdeSvkuNseRg
KZP6Qq4GIMAZZ2hv1JC/xDxZs/59ACuL0IsjmdZPEiR8uiF01ZejehmdFiPJJP8at+PJgnoW
hW21Gh72CYI3CjvfB37Q5fUOqF1gMsfJmsJokwYfLLy8BcWbmP5BQ8IOL42F2RsuPTctnnbS
hhYj73Qyp4/Mxzeg1r34ZevEqM1pX6ceW7I/7Aos8HmhbcW71KMCAwEAAaOCAfswggH3MAwG
A1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgSwMB0GA1UdDgQWBBTeMPDcRbuXT/FdxHmf8kNH
EWVOVjAfBgNVHSMEGDAWgBTGdckorNEL/Dz/ubUe0187gGISNDAlBgNVHREEHjAcgRpDYXJz
dGVuLkF1bGJlcnRAYWVpLm1wZy5kZTAcBgNVHRIEFTATgRFncmlka2EtY2FAa2l0LmVkdTA1
BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vZ3JpZC5memsuZGUvY2EvZ3JpZGthLWNybC5kZXIw
KAYDVR0gBCEwHzAPBg0rBgEEAZQ2qywBAQEIMAwGCiqGSIb3TAUCAgEwEQYJYIZIAYb4QgEB
BAQDAgWgME4GCWCGSAGG+EIBDQRBFj9DZXJ0aWZpY2F0ZSBpc3N1ZWQgdW5kZXIgQ1AvQ1BT
IHYuIDEuOCBhdCBodHRwOi8vZ3JpZC5memsuZGUvY2EwJAYJYIZIAYb4QgECBBcWFWh0dHA6
Ly9ncmlkLmZ6ay5kZS9jYTAzBglghkgBhvhCAQgEJhYkaHR0cDovL2dyaWQuZnprLmRlL2Nh
L2dyaWRrYS1jcHMucGRmMDMGCWCGSAGG+EIBAwQmFiRodHRwOi8vZ3JpZC5memsuZGUvY2Ev
Z3JpZGthLWNybC5kZXIwDQYJKoZIhvcNAQEFBQADggEBALkdDvMzLkK1EpFkRPxEA4GpbYyy
5p59V9057HT/QUYvD7rO5KiayiRoDqgKeDW59Fek1N5W0d2IuN+j+VWLDqlBI1THd33F3Dqc
08Me/q6OkpHDjhCDnuH353n2gyxnsmXEEMozhx4onJbX0N3kZxjgNKEiP9R+zOq6Qq+CgKFS
O5w/wdtCTQ5Tpfr/n90KWYwVQ2er5dnKowu6j9YIj/dD8jJGk3T13rgzdnRzWtSQhjP8YIRf
ql08NsUgDShjNiBo289K7fpBNdVLGNI/pIA8P1ratofCGBPvMdjp+cjhulQX5//qS1ctP0ux
8MhY3kBMGynLkwibH5MiLfVSip0xggLOMIICygIBATA8MDYxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpHZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMAkGBSsOAwIaBQCgggFn
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDgxMDE4MDU0
MlowIwYJKoZIhvcNAQkEMRYEFN6VhMsRUKgeCmE3M+2tr/zPbrGbMEsGCSsGAQQBgjcQBDE+
MDwwNjELMAkGA1UEBhMCREUxEzARBgNVBAoTCkdlcm1hbkdyaWQxEjAQBgNVBAMTCUdyaWRL
YS1DQQICT9AwTQYLKoZIhvcNAQkQAgsxPqA8MDYxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpH
ZXJtYW5HcmlkMRIwEAYDVQQDEwlHcmlkS2EtQ0ECAk/QMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEA
ki1VSEfKQ6BemJx/EcuBp4mJOP7kBNQhV4K9zXzbSjd65mGi0GHUC/m4639gBgDQryCijGZ4
cSiMdYIHr9DctQlGSFMQvnNNoI20PMlH1lZ0XO32WUue0ewM+vjk+Ge0U9xzwBAKib6Ie/+R
hlRFPYtxepVYuQ7Tj2aDNdArZwfXPKcjjzqc5UZOxKy7XxULwrRaTJ/qRVMjuJWIFh/OUQAO
89Yb/7pcdVpJtbRhQZzYq5IREoPcv+ieYeTrCER8WUpdEOzYSpfz/+Yz+eZ/HQ1/rhHE1GI1
fRWhvmheRMKGWOfSXD9Jb9XwcToceUVDkLFlBMcO/9AsC//R69Z4kwAAAAAAAA==
--------------ms080700000802020106030705--
