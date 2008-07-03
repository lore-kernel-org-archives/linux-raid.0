From: Jon Buckingham <jbuckingham@blueyonder.co.uk>
Subject: Re: [Fwd: Re: mdadm: spare rebuilding]
Date: Thu, 03 Jul 2008 08:10:26 +0100
Message-ID: <486C7B62.1@blueyonder.co.uk>
References: <486A7974.4070204@blueyonder.co.uk> <55776.192.168.1.70.1214992071.squirrel@neil.brown.name>
Reply-To: jbuckingham@blueyonder.co.uk
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms080609040205070002020802"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55776.192.168.1.70.1214992071.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms080609040205070002020802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Neil

So, a little while ago I did upgrade the kernel
(2.6.22.18-0.2-default), but it did not seem to make any difference to the
'echo sync > /sys/block/md3/md/sync_action'.

After receiving your latest email, I did the following...

echo sync > /sys/block/md3/md/sync_action
(device busy reported to konsole as before)
echo idle > /sys/block/md3/md/sync_action
echo sync > /sys/block/md3/md/sync_action
(device busy reported to konsole as before)

Then checked "top" - and saw significant activity from
md3_sync and md3_raid5 processes.
Also cat /proc/mdstat showed that a resync was actively happening,
and sure enough, after a couple of hours I now have
4 active devices in the array!

So I suspect a combination of the new kernel and the "idle"
sorted the problem, whatever it was.

Thanks!
And thanks for writing mdadm and for your support.

Jon B

NeilBrown wrote:
> On Wed, July 2, 2008 4:37 am, Jon Buckingham wrote:
>> Hi Neil - any thoughts on how I can debug/fix this?
> 
> Sorry for the slow responses - I seem to have been very busy lately.
> 
> No, unmount isn't needed.
> I cannot really imagine what is happening.
> Maybe write "idle" to the sync_action file first, then try
> "sync", but that seems unlikely.
> 
> Maybe unmount, stop the array,
>    echo 0 > /sys/modules/md-mod/paramters/start_ro
> and assemble that array again
>    mdadm -A /dev/md3 /dev/sd[abcd]4
> and see if that helps.
> 
> Maybe try a newer kernel if that is an option.
> 
> NeilBrown
> 
>> Thanks
>>
>> Jon B
>>
>> -------- Original Message --------
>> Subject: Re: mdadm: spare rebuilding
>> Date: Sat, 28 Jun 2008 20:42:56 +0100
>> From: Jon Buckingham <jbuckingham@blueyonder.co.uk>
>> Reply-To: jbuckingham@blueyonder.co.uk
>> To: Neil Brown <neilb@suse.de>
>> CC: linux-raid@vger.kernel.org
>> References: <48615EE7.7000502@blueyonder.co.uk>
>> <18532.47293.808234.949005@notabene.brown>
>>
>> Neil Brown wrote:
>>> Maybe a bug that has since been fixed.
>>> What happens if you
>>>   echo sync > /sys/block/md3/md/sync_action
>>> ??
>>>
>> nas:~ # echo sync > /sys/block/md3/md/sync_action
>> -bash: echo: write error: Device or resource busy
>>
>> Should I unmount first?
>> Any other info?
>>
>> Thanks
>>
>> Jon B
>>
>>
>>
> 
> 
> 


--------------ms080609040205070002020802
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJLzCC
AvIwggJboAMCAQICED+2nVJ0BG6weLaGhJbjTK4wDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDMxNzIwNDcyM1oX
DTA5MDMxNzIwNDcyM1owTjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjErMCkG
CSqGSIb3DQEJARYcamJ1Y2tpbmdoYW1AYmx1ZXlvbmRlci5jby51azCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMpt089Gj6mNQnCzJzLATutrPfBKs8EgZz+I0Id+fiiwSCbp
zDnOay4itz4EyXgsUw/zcZyMNwT+JJQiznaSlHagGZs5AiA059yvLuLb6C0FrMOFjpREHJDf
mdA6lSEeNjCHUEPNkvZvrAapQdK2QtCQhJcoacYAy97+FLSOaRlFO99Ggq6/ROvF2SU2kPQj
omE5t3uOHtm4GbGblbwaUztHFWB7d6WKyLJF8AeDHSKVqBMd1I4JhttdZsTz6lLc6csVB+do
6+EYWkrttS14Nyprw91a9OxtY6m8zFBNgQR460IvdEmCwHdTF4krE0LSTVXRvyrmvpdz3oN2
HVBGlY0CAwEAAaM5MDcwJwYDVR0RBCAwHoEcamJ1Y2tpbmdoYW1AYmx1ZXlvbmRlci5jby51
azAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAAq+YglaqniAq4ToNKx/yTvPTdT3
eo34CLo1IoYz5b0e23QgiOxPWdahf59uxytDE0oq9GGj4HvrQazG9oKd+pEMikT9FJnIrjRW
02jCYrO90/060ovsQX1KPYpSC9WtCLQlg7LRmq9a8sYkbpbu/qx5KdtixduIs/ZyPV5ZyOcW
MIIC8jCCAlugAwIBAgIQP7adUnQEbrB4toaEluNMrjANBgkqhkiG9w0BAQUFADBiMQswCQYD
VQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UE
AxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwHhcNMDgwMzE3MjA0NzIz
WhcNMDkwMzE3MjA0NzIzWjBOMR8wHQYDVQQDExZUaGF3dGUgRnJlZW1haWwgTWVtYmVyMSsw
KQYJKoZIhvcNAQkBFhxqYnVja2luZ2hhbUBibHVleW9uZGVyLmNvLnVrMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAym3Tz0aPqY1CcLMnMsBO62s98EqzwSBnP4jQh35+KLBI
JunMOc5rLiK3PgTJeCxTD/NxnIw3BP4klCLOdpKUdqAZmzkCIDTn3K8u4tvoLQWsw4WOlEQc
kN+Z0DqVIR42MIdQQ82S9m+sBqlB0rZC0JCElyhpxgDL3v4UtI5pGUU730aCrr9E68XZJTaQ
9COiYTm3e44e2bgZsZuVvBpTO0cVYHt3pYrIskXwB4MdIpWoEx3UjgmG211mxPPqUtzpyxUH
52jr4RhaSu21LXg3KmvD3Vr07G1jqbzMUE2BBHjrQi90SYLAd1MXiSsTQtJNVdG/Kua+l3Pe
g3YdUEaVjQIDAQABozkwNzAnBgNVHREEIDAegRxqYnVja2luZ2hhbUBibHVleW9uZGVyLmNv
LnVrMAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEACr5iCVqqeICrhOg0rH/JO89N
1Pd6jfgIujUihjPlvR7bdCCI7E9Z1qF/n27HK0MTSir0YaPge+tBrMb2gp36kQyKRP0Umciu
NFbTaMJis73T/TrSi+xBfUo9ilIL1a0ItCWDstGar1ryxiRulu7+rHkp22LF24iz9nI9XlnI
5xYwggM/MIICqKADAgECAgENMA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMG
A1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0
ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9u
MSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEW
HHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2
MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0
eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0Ew
gZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9
zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPP
K9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGj
gZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3Js
LnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYw
KQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEB
BQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9
reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo0
5RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIDZDCCA2ACAQEwdjBiMQswCQYDVQQGEwJa
QTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhh
d3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECED+2nVJ0BG6weLaGhJbjTK4wCQYF
Kw4DAhoFAKCCAcMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
MDgwNzAzMDcxMDI2WjAjBgkqhkiG9w0BCQQxFgQUGhVJP9m/I/Cm01hsGaPaUhW0PRAwUgYJ
KoZIhvcNAQkPMUUwQzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhA/tp1SdARusHi2hoSW40yu
MIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBD
b25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBJc3N1aW5nIENBAhA/tp1SdARusHi2hoSW40yuMA0GCSqGSIb3DQEBAQUABIIBAInoMT6d
rwWkeXHoXATOPLM8RpCStfadj/+Pvyax3vVmUNoTFzjo5rk4eho+7j0MCjLQIh7yEmbcu7Pq
n1XUe4dZfHQ0EkPXL1TEhtUtfft1Gbt5Ckdzqq66D+Bd34B+/v9GwvfN5yLknFPfyTe8DUKS
UC7e8vpYGOasz+DDgMvXLPaW766e9fc2LeYUFTLmuaDHYyH6RK4Gcz73DTSUowpLHuJ0brcJ
cH+s6A8x9i0/Z6VRT7XDAkRMqzFMyIKabGeysIRfgQ8Eq0MDDb3LfhtoVYh/Bd3iT/Fur/BD
4cg9VCnlNclVK2Lsmwc61yWMVj71mYMn/4CR/5lFeqU8QvcAAAAAAAA=
--------------ms080609040205070002020802--

