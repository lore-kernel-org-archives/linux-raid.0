From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Speeding up chunk size change?
Date: Sun, 04 Mar 2012 11:56:39 +1100
Message-ID: <4F52BDC7.5070805@crc.id.au>
References: <4F5272C9.3010906@crc.id.au> <4F52904E.10203@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000206000606090901010408"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F52904E.10203@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms000206000606090901010408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/03/2012 8:42 AM, Stan Hoeppner wrote:
> On 3/3/2012 1:36 PM, Steven Haigh wrote:
>> Hi all,
>>
>> I just wanted to run this past a few folk here as I want to make sure
>> I'm doing it the Right Way(tm).
>>
>> I've decided to experiment with using a 128Kb chunk size on my RAID6
>> instead of a 64kb chunk.
>
> Why?  Does your target application(s) perform better with a larger
> chunk, and therefore larger total stripe size?  If you're strictly afte=
r
> larger dd copy numbers then you're wasting everyone's time, including
> yours, as such has almost zero bearing on real world performance, as
> most workloads are far more random than sequential.

Purely experimental for fun and education. I actually thought that a=20
reshape would go at somewhat near the resync speeds I get of=20
~60-90Mb/sec. I guess this shows I'm wrong ;)

> And apparently you're not using XFS.  This reshape will screw up your
> alignment, and you'll need to change your fstab mount to reflect the ne=
w
> RAID geometry.  But my guess is you're not using.  If you were you'd
> probably be experienced enough to know that doubling your chunk size
> isn't going to make much difference, if any, in real world system usage=
=2E

I do use XFS - but this machines role is a Xen Dom0 - so md2 holds the=20
filesystems for the guest VMsin LVs. One of those guest filesystems is=20
an LV of the VG on md2 formatted as XFS. It will be interesting to see=20
how this affects things :)

>> I set a few 'optimisations' that I believe should help:
>> ## Tweak the RAIDs
>> blockdev --setra 8192 /dev/sd[abcdefg]
>
> Read-ahead is per file descriptor, and occurs at the filesystem level.
> The read-ahead value used is that of the device immediately underlying
> the filessytem.  So don't bother setting these above.

Interesting - I didn't think that was the case for whole disk arrays -=20
but there you go... Learnt something else :)

>> blockdev --setra 8192 /dev/md0
>> blockdev --setra 8192 /dev/md1
>> blockdev --setra 16384 /dev/md2
>
> This is fine.  You could theoretically set this to 1GB or more if you
> always read entire files, with no ill effects, as read-ahead doesn't go=

> past EOF.  However if you do any mmap reads (many apps do) of portions
> of large files, this will hammer performance, obviously, as you're
> reading entire large files speculatively when not needed.  Play with
> this at your own risk.

The workloads of the array (having LVM on top) for the VMs would=20
probably make it quite random. This is part of the reason I am playing=20
here - pure experimentation. I am very curious to see if it works better =

or worse after the reshape. I honestly don't know :)

>> echo 16384>  /sys/block/md2/md/stripe_cache_size
>>
>> for i in sda sdb sdc sdd sde sdf; do
>>          echo "Setting options for $i"
>>          echo 256>  /sys/block/$i/queue/nr_requests
>>          echo 4096>  /sys/block/$i/queue/read_ahead_kb
> Eliminate this line ^^^^

Any insight into why? I would have thought that this would help -=20
however I'm not quite sure as to the values - as this is much less than=20
one chunk... That also being said, wouldn't it be a good idea to have=20
*some* readahead?

>>          echo 1>  /sys/block/$i/device/queue_depth
>>          echo deadline>  /sys/block/$i/queue/scheduler
>> done
>>
>> Just wondering if anyone knows of any possible way to speed up the
>> reshape a little, or if (like I suspect) it will take ~2 days to
>> complete the reshape.
>
> Considering how expensive such operations are in both time and wear on
> the disk drives, it's better to read everything available to you on the=

> subject and ask questions *before* performing expensive experiments on
> your array.  If you currently have an performance problem you're trying=

> to solve, the cause lay somewhere other than your chunk size.

As I said above, there really is no 'problem' I'm trying to solve. The=20
whole reason is experimentation and education - really to see a 'what=20
if' case. The last reshape I did on this array was a RAID5->RAID6 grow=20
which went very well - however I have never experimented with chunk size =

on a mdadm raid.

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299


--------------ms000206000606090901010408
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOSjCC
BjQwggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDE1NVoXDTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOr
lr6KMoOMpohBllVHrdRvEg/q6r8jR+EK75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSM
zR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6
qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxDz2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSD
kOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr/+N2JLKutIxMYqQOJebr/f/h5t95
m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFcfH6WNU7y1LhRgjAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqD
CH14qywGXLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy
6QMVQjbbMXltUfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPI
zKKR9tQW8gGK+2+RHxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKf
KSETEPrHh7p5shuuNktvsv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HOR
z9v3vQwR4e3ksLc2JZOAFK+ssS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9
sIPP7ON0fz095HdThKjiVJe6vofq+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCie
uoBJ9OlqmsVWQvifIYf40dJPZkk9YgGTzWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7t
w1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGqUp/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQ
G2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb19mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t
5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIIDjCCBvagAwIBAgIDA7ikMA0GCSqGSIb3DQEB
BQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20g
Q2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTIwMjEzMTMzODE0
WhcNMTMwMjEzMTc1NjUzWjBXMRkwFwYDVQQNExB3bjVlU1RNM2RWOUIwMEk5MRkwFwYDVQQD
DBBuZXR3aXpAY3JjLmlkLmF1MR8wHQYJKoZIhvcNAQkBFhBuZXR3aXpAY3JjLmlkLmF1MIIC
IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAzTaLiL78pm4Hqp7Pou4C60jt2wdvDiPt
Sq6hspKk6oaST7BFeDOfoed3mvzytkjNr3C1gds3zsHulAMzRjuX2M1zPkfaj5QFkmlqQcxr
+tnaf8QFpn9PrUcjpbYDYPxdcGR+SeClKzmjdxicHuYDrD8YXnbk+k8dWDaCuv5sKRQHJmIR
maqUIGoVML+/kUR+sqkMpnbhOsL+E84Hg4fxLzpV3Tjf9bZbKgaspvg+BeJJCYKThBxMnZJI
cQ9JzDGL4rO2BEuTXI9Ofl0+AAttBEpZeqc2rePCfA9NivKTCZ0qaFKmvM5SN7TiZUqv80rD
ewTp+OLXNZEd5aa5jEDPNlznkcX0WfuKCmtyIEzT7PgHl1tOWTx7nw6FVWcB8qjC6xlyaL6W
1oS7Om3b2ka+9vSiz7DrPZzUDZuS91Fr2zIIMrrRzhN8q/JdQf8lGTydpmoRUB0z+BAcH8V/
nOcMMDogqV6/dCfywi7zFQK4AsiPSpyBAZyO53J4uPgoIzSpFj54f83KRIobHCWDU1BaU2+6
CfEoAD3iMId1tcFWTXikEThL+3oHQullq9EbPR4f3ToAU7aTZYWG4KNKrmG93KAfyCUFb+bf
mt3hf1BprKIUJnpOxdZHi0KwLXVwURiB4XQKZpEWL8mRbHRdxVATKrrJAHOFTl3/s37VLprP
J9kCAwEAAaOCA6swggOnMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdJQQWMBQGCCsG
AQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUS9is0NdoOI3DZ/36Zlq78IrSedgwHwYDVR0j
BBgwFoAUU3Ltkpzg2ssBXHx+ljVO8tS4UYIwGwYDVR0RBBQwEoEQbmV0d2l6QGNyYy5pZC5h
dTCCAiEGA1UdIASCAhgwggIUMIICEAYLKwYBBAGBtTcBAgIwggH/MC4GCCsGAQUFBwIBFiJo
dHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMDQGCCsGAQUFBwIBFihodHRwOi8v
d3d3LnN0YXJ0c3NsLmNvbS9pbnRlcm1lZGlhdGUucGRmMIH3BggrBgEFBQcCAjCB6jAnFiBT
dGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+VGhpcyBjZXJ0aWZpY2F0
ZSB3YXMgaXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMSBWYWxpZGF0aW9uIHJlcXVp
cmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCByZWxpYW5jZSBvbmx5IGZvciB0
aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRoZSByZWx5aW5nIHBhcnR5
IG9ibGlnYXRpb25zLjCBnAYIKwYBBQUHAgIwgY8wJxYgU3RhcnRDb20gQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkwAwIBAhpkTGlhYmlsaXR5IGFuZCB3YXJyYW50aWVzIGFyZSBsaW1pdGVk
ISBTZWUgc2VjdGlvbiAiTGVnYWwgYW5kIExpbWl0YXRpb25zIiBvZiB0aGUgU3RhcnRDb20g
Q0EgcG9saWN5LjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9j
cnR1MS1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2Nz
cC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMS9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6
Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczEuY2xpZW50LmNhLmNydDAjBgNV
HRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEBABL6
TyHlAHW0kkHb0ZLcd/pn7Ue0B5mIWBhmta4dK8qd0hXw+/lhpWaJWR/RltCSPabxSd+Lm9Iw
NWm7WP73GHAGby0TC+siwDJSk7CwDBqnVM1T3XQ5TgjfVX7h9qjVixsSWzAD++dXFmpf/344
Uf3zcG/hKJSeRtOvM/88nn4eJtrn7QFnIm4AJpHEgrqwU/0pmQBLwmEYS1G5cr04Oact2v6W
L3JHOlEP8lPBAO9GtZD8UZGmBoDTNG0Rf4TnVTBGdw1sLZqpXnkcVI+rDUaFk/jb7AtCB30N
8tbm2I5ALevgjv+vNMZIQD/0AgOaylGrQwbP852lgOvMo2AdpGExggTQMIIEzAIBATCBlDCB
jDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3Vy
ZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNz
IDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMDuKQwCQYFKw4DAhoFAKCCAhAw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTIwMzA0MDA1NjM5
WjAjBgkqhkiG9w0BCQQxFgQUIjFjOMqjBjvhWI0R+Xy9/Ouq0nYwXwYJKoZIhvcNAQkPMVIw
UDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGlBgkrBgEEAYI3EAQxgZcwgZQwgYwxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGln
aXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFBy
aW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQIDA7ikMIGnBgsqhkiG9w0BCRACCzGBl6CB
lDCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNl
Y3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENs
YXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMDuKQwDQYJKoZIhvcNAQEB
BQAEggIApy+vpCugP7FWit9aJ8kj6w1fxLq1m3VFZm1aestJPMCJ0LXK7YzGkZqGCwP+E6g+
4vaSIqE/pBsvTcIMbWZ4Zo7UZek37sgtNFjNWZxyTC3OriDRnNsrSu4myTpxqEoNRFjbaQus
bwcGGJmUSuSm+527QvmSVBGquApvYKimoDS/0fXX98f5Nr54Cg7h2JI96zLsSP6tSHDx7x/w
nyIJqKjq8HGfQJTrn6NP0HTOVgIj7qoETf3TPIF6UrADbRQG7l3Md3cfnV9hV79MIf65F6/u
GJzy0FhLCV/V3vJegFATyjcry4e0bE0mgvDoSQUYUzJCLUdjBDSkEwRwMJk63V7IpYIBGPtF
hB9AMvibbVFW/UU0TwMmSriqXG8pAqwFiELqJ/8uYrth/1CaBa6P7CuQv1o6LvALUGHMQHVc
ulGy6AifTsp18hWGK+4y/6e9ajhwMkTR/EYn1Y1tenB7XDDwaoC7/4Nbh7P2C1i4VLbuLxSM
VccywacDcIg9W/6Z1CfYEaoWj6kqJ7J3sciMsy+Ta5S3+hyO3LqWPH75SgHHTykvb0jlSqeD
hFVtF2WC2Dt8B39Y76IldZ7fbR+W721sSdogw2AtnBVXepBdV+vCnIb2HSK7XLVBA/6PhabT
q9SaUErcp+1bgxfmpfj7DjSpBbMg6GJjiHx4SeozvH4AAAAAAAA=
--------------ms000206000606090901010408--
