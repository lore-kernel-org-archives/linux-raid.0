From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Fri, 9 Feb 2018 21:52:38 +0100
Message-ID: <59144df0-35b7-942f-22c8-754afd0f89c4@uni-konstanz.de>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org>
 <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
 <20180209202958.6mieeomu5of45rjf@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020506020904070701020109"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180209202958.6mieeomu5of45rjf@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Phil Turmel <philip@turmel.org>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms020506020904070701020109
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable



Am 09/02/18 um 21:29 schrieb Marc MERLIN:
> On Fri, Feb 09, 2018 at 03:13:26PM -0500, Phil Turmel wrote:
>>> The pending sectors should have been re-written and become
>>> Reallocated_Event_Count, no?
>>
>> Yes, and not necessarily.  Pending sectors can be non-permanent errors=

>> -- the drive firmware will test a pending sector immediately after wri=
te
>> to see if the write is readable.  If not, it will re-allocate while it=

>> still has the write data in its buffers.  Otherwise, it'll clear the
>> pending sector.
>=20
> This shows the sector is still bad though, right?=20
>=20
> myth:~# hdparm --read-sector 1287409520 /dev/sdh
> /dev/sdh:
> reading sector 1287409520: SG_IO: bad/missing sense data, sb[]:  70 00 =
03 00 00 00 00 0a 40 51 e0 01 11 04 00 00 a0 70 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 succeeded
> 7000 0b54 92c4 ffff 0000 0000 01fe 0000
> (...)
>=20
> [ 2572.139404] ata5.04: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x=
0
> [ 2572.139419] ata5.04: failed command: READ SECTOR(S) EXT
> [ 2572.139427] ata5.04: cmd 24/00:01:70:4f:bc/00:00:4c:00:00/e0 tag 28 =
pio 512 in
> [ 2572.139427]          res 51/40:01:70:4f:bc/00:00:4c:00:00/e0 Emask 0=
x9 (media error)
> [ 2572.139431] ata5.04: status: { DRDY ERR }
> [ 2572.139435] ata5.04: error: { UNC }
> [ 2572.162369] ata5.04: configured for UDMA/133
> [ 2572.162414] ata5: EH complete
>=20
> mdadm also said it found 6 bad sectors and rewrote them (or something l=
ike that)
> and it's happy. So alledgely it did something, but smart does not agree=
 (yet?)
>=20
> I'm now running a long smart test on all drives, will see if numbers ch=
ange.
>=20
> Mmmh, and I just ran=20
> myth:~# badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
> below, and I don't quite understand what's going on.
>=20
>>> So, mdadm is happy allegedly, but my drives still have the same bad
>>> sectors they had (more or less).
>>
>> If you have bad block lists enabled in your array, MD will *never* try=

>> to fix the underlying sectors.  Please show your mdadm -E reports for
>> these devices.  If necessary, stop the array and re-assemble with the
>> options to disable bad block lists.  { How this misfeature got into th=
e
>> kernel and enabled by default baffles me. }
>=20
> This means I dont have bad block lists?
> myth:~# mdadm -E /dev/sdd e f g h all return
> /dev/sdd:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
>=20
>> Also, pending sectors that are in dead zones between metadata and arra=
y
>> data will not be accessed by a check scrub, and will therefore persist=
=2E
> =20
> That's a good point, but then I would never have discovered those block=
s
> while initializing the array.
>=20
>>> Yes, I know I should trash (return) those drives,
>>
>> Well, non-permanent read errors are not considered warranty failures.
>> They are in the drive specs.  When pending is zero and actual
>> re-allocations are climbing (my threshold is double digits), *then* it=
's
>> time to replace.
>=20
> I think it's worse here. Read errors are not being cleared by block rew=
rites?
> Those are brand "new" (but really remanufactured) drives.=20
> So far I'm not liking what I'm seeing and I'm very close to just
> returning them all and getting some less dodgy ones.
>=20
> Sad because the last set of 5 I got from a similar source, have worked
> beautifully.
>=20
> Let's see what a full smart scan does.
> I may also use hdparm --write-sector to just fill those bad blocks with=
 0's
> now that it seems that mdadm isn't caring about/using them anymore?
>=20
> Now, badblocks perplexes me even more. Shouldn't -n re-write blocks?
>=20
> myth:~# badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
> /dev/sdh is apparently in use by the system; badblocks forced anyway.
> Checking for bad blocks in non-destructive read-write mode
> From block 1287409400 to 1287409599
> Checking for bad blocks (non-destructive read-write test)
> Testing with random pattern: 1287409520ne, 0:14 elapsed. (0/0/0 errors)=

> 1287409521ne, 0:18 elapsed. (1/0/0 errors)
> 1287409522ne, 0:23 elapsed. (2/0/0 errors)
> 1287409523ne, 0:27 elapsed. (3/0/0 errors)
> 1287409524ne, 0:31 elapsed. (4/0/0 errors)
> 1287409525ne, 0:36 elapsed. (5/0/0 errors)
> 1287409526ne, 0:40 elapsed. (6/0/0 errors)
> 1287409527ne, 0:44 elapsed. (7/0/0 errors)
> done                                                =20
> Pass completed, 8 bad blocks found. (8/0/0 errors)
>=20
> Badblocks found 8 bad blocks, but didn't rewrite them, or failed to, or=

> succeeded but that did nothing anyway?
>=20
> Do I understand that
> 1) badblocks got read errors
> 2) it's supposed to rewrite the blocks with new data (or not?)
> 3) auto reallocate failed
>=20
>=20
> [ 3171.717001] ata5.04: exception Emask 0x0 SAct 0x40 SErr 0x0 action 0=
x0
> [ 3171.717012] ata5.04: failed command: READ FPDMA QUEUED=20
> [ 3171.717019] ata5.04: cmd 60/08:30:70:4f:bc/00:00:4c:00:00/40 tag 6 n=
cq dma 4096 in
> [ 3171.717019]          res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0=
x409 (media error) <F>
> [ 3171.717031] ata5.04: status: { DRDY ERR }=20
> [ 3171.717034] ata5.04: error: { UNC }
> [ 3171.718293] ata5.04: configured for UDMA/133
> [ 3171.718342] sd 4:4:0:0: [sdh] tag#6 FAILED Result: hostbyte=3DDID_OK=
 driverbyte=3DDRIVER_SENSE
> [ 3171.718349] sd 4:4:0:0: [sdh] tag#6 Sense Key : Medium Error [curren=
t]=20
> [ 3171.718354] sd 4:4:0:0: [sdh] tag#6 Add. Sense: Unrecovered read err=
or - auto reallocate failed=20
> [ 3171.718360] sd 4:4:0:0: [sdh] tag#6 CDB: Read(16) 88 00 00 00 00 00 =
4c bc 4f 70 00 00 00 08 00 00
> [ 3171.718364] print_req_error: I/O error, dev sdh, sector 1287409520=20
> [ 3171.718369] Buffer I/O error on dev sdh, logical block 160926190, as=
ync page read
> [ 3171.718393] ata5: EH complete
> [ 3176.092946] ata5.04: exception Emask 0x0 SAct 0x400000 SErr 0x0 acti=
on 0x0
> [ 3176.092958] ata5.04: failed command: READ FPDMA QUEUED
> [ 3176.092973] ata5.04: cmd 60/08:b0:70:4f:bc/00:00:4c:00:00/40 tag 22 =
ncq dma 4096 in=20
> [ 3176.092973]          res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0=
x409 (media error) <F>
> [ 3176.092978] ata5.04: status: { DRDY ERR }
> [ 3176.092981] ata5.04: error: { UNC }=20
> [ 3176.094237] ata5.04: configured for UDMA/133
> [ 3176.094285] sd 4:4:0:0: [sdh] tag#22 FAILED Result: hostbyte=3DDID_O=
K driverbyte=3DDRIVER_SENSE=20
> [ 3176.094291] sd 4:4:0:0: [sdh] tag#22 Sense Key : Medium Error [curre=
nt]=20
> [ 3176.094296] sd 4:4:0:0: [sdh] tag#22 Add. Sense: Unrecovered read er=
ror - auto reallocate failed
> [ 3176.094302] sd 4:4:0:0: [sdh] tag#22 CDB: Read(16) 88 00 00 00 00 00=
 4c bc 4f 70 00 00 00 08 00 00=20
> [ 3176.094306] print_req_error: I/O error, dev sdh, sector 1287409520
> [ 3176.094310] Buffer I/O error on dev sdh, logical block 160926190, as=
ync page read
> [ 3176.094324] ata5: EH complete
> [ 3180.488899] ata5.04: exception Emask 0x0 SAct 0x100 SErr 0x0 action =
0x0
> [ 3180.488909] ata5.04: failed command: READ FPDMA QUEUED=20
> [ 3180.488916] ata5.04: cmd 60/08:40:70:4f:bc/00:00:4c:00:00/40 tag 8 n=
cq dma 4096 in
> [ 3180.488916]          res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0=
x409 (media error) <F>=20
> [ 3180.488928] ata5.04: status: { DRDY ERR }
> [ 3180.488931] ata5.04: error: { UNC }
> [ 3180.490193] ata5.04: configured for UDMA/133
> [ 3180.490243] sd 4:4:0:0: [sdh] tag#8 FAILED Result: hostbyte=3DDID_OK=
 driverbyte=3DDRIVER_SENSE
> [ 3180.490249] sd 4:4:0:0: [sdh] tag#8 Sense Key : Medium Error [curren=
t] =20
> [ 3180.490254] sd 4:4:0:0: [sdh] tag#8 Add. Sense: Unrecovered read err=
or - auto reallocate failed
> [ 3180.490259] sd 4:4:0:0: [sdh] tag#8 CDB: Read(16) 88 00 00 00 00 00 =
4c bc 4f 70 00 00 00 08 00 00
> [ 3180.490263] print_req_error: I/O error, dev sdh, sector 1287409520=20
> [ 3180.490268] Buffer I/O error on dev sdh, logical block 160926190, as=
ync page read
> [ 3180.490290] ata5: EH complete=20
> [ 3184.873146] ata5.04: exception Emask 0x0 SAct 0x1000000 SErr 0x0 act=
ion 0x0
> [ 3184.873161] ata5.04: failed command: READ FPDMA QUEUED
> [ 3184.873175] ata5.04: cmd 60/08:c0:70:4f:bc/00:00:4c:00:00/40 tag 24 =
ncq dma 4096 in=20
> [ 3184.873175]          res 41/40:00:70:4f:bc/00:00:4c:00:00/00 Emask 0=
x409 (media error) <F>
> [ 3184.873181] ata5.04: status: { DRDY ERR }
> [ 3184.873184] ata5.04: error: { UNC }
> [ 3184.874437] ata5.04: configured for UDMA/133
> [ 3184.874488] sd 4:4:0:0: [sdh] tag#24 FAILED Result: hostbyte=3DDID_O=
K driverbyte=3DDRIVER_SENSE
> [ 3184.874495] sd 4:4:0:0: [sdh] tag#24 Sense Key : Medium Error [curre=
nt]=20
> [ 3184.874500] sd 4:4:0:0: [sdh] tag#24 Add. Sense: Unrecovered read er=
ror - auto reallocate failed
> [ 3184.874506] sd 4:4:0:0: [sdh] tag#24 CDB: Read(16) 88 00 00 00 00 00=
 4c bc 4f 70 00 00 00 08 00 00
> [ 3184.874510] print_req_error: I/O error, dev sdh, sector 1287409520
> [ 3184.874515] Buffer I/O error on dev sdh, logical block 160926190, as=
ync page read
> [ 3184.874555] ata5: EH complete
>=20

What you write about the result of
badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
is the expected behavior. -n means that it will _not_ write sectors that
it cannot read (because that would remove the possibility that data from
these sectors could be recovered by more tries).

As I wrote, you have to use the -w option instead of -n, and use x and y
of 1287409527 1287409520

HTH
Kay



--------------ms020506020904070701020109
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
D+kwggTVMIIDvaADAgECAghQTsb1PRG0ZDANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJE
RTEcMBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRy
dXN0IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQw
NzIyMTIwODI2WhcNMTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZO
LVZlcmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xv
YmFsIC0gRzAxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTD
llA1PWLpbkztlNcAW5UidNQg6zSP1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1
OXstkEXQ7aAAeny/Sg4bAMOG6VwrMRF7DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8B
r3QPwQmi9mvOvdPNFDBP9eXjpMhim4IaAycwDQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9
bzOz2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO72uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSa
cXXFbOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQABo4IBhjCCAYIwDgYDVR0PAQH/BAQD
AgEGMB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAfBgNVHSMEGDAWgBQxw3kbuvVT
1xfgiXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMGIGA1UdIARbMFkwEQYPKwYBBAGB
rSGCLAEBBAICMBEGDysGAQQBga0hgiwBAQQDADARBg8rBgEEAYGtIYIsAQEEAwEwDwYNKwYB
BAGBrSGCLAEBBDANBgsrBgEEAYGtIYIsHjA+BgNVHR8ENzA1MDOgMaAvhi1odHRwOi8vcGtp
MDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweAYIKwYBBQUHAQEEbDBqMCwG
CCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA6BggrBgEFBQcw
AoYuaHR0cDovL3BraTAzMzYudGVsZXNlYy5kZS9jcnQvRFRfUk9PVF9DQV8yLmNlcjANBgkq
hkiG9w0BAQsFAAOCAQEAYyAo/ZwhhnK+OUZZOTIlvKkBmw3Myn1BnIZtCm4ssxNZdbEzkhth
Jxb/w7LVNYL7hCoBSb1mu2YvssIGXW4/buMBWlvKQ2NclbbhMacf1QdfTeZlgk4y+cN8ekvN
TVx07iHydQLsUj7SyWrTkCNuSWc1vn9NVqTszC/Pt6GXqHI+ybxA1lqkCD3WvILDt7cyjrEs
jmpttzUCGc/1OURYY6ckABCwu/xOr24vOLulV0k/2G5QbyyXltwdRpplic+uzPLl2Z9Tsz6h
L5Kp2AvGhB8Exuse6J99tXulAvEkxSRjETTMWpMgKnmIOiVCkKllO3yG0xIVIyn8LNrMOVtU
FzCCBUIwggQqoAMCAQICBxeQYOCzPaowDQYJKoZIhvcNAQELBQAwWjELMAkGA1UEBhMCREUx
EzARBgNVBAoTCkRGTi1WZXJlaW4xEDAOBgNVBAsTB0RGTi1QS0kxJDAiBgNVBAMTG0RGTi1W
ZXJlaW4gUENBIEdsb2JhbCAtIEcwMTAeFw0xNDA1MTIxNTA1NTJaFw0xOTA3MDkyMzU5MDBa
MGYxCzAJBgNVBAYTAkRFMRUwEwYDVQQKEwxVbmktS29uc3RhbnoxHTAbBgNVBAMTFFVuaS1L
b25zdGFueiBDQS1TMDAxMSEwHwYJKoZIhvcNAQkBFhJjYUB1bmkta29uc3RhbnouZGUwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCv07T95IkjXCFklVv9IjNJyK271LN0qNFz
hLUFscans64sLOUveaaw0xgQAN4N95WE6KxHUTVmCwM9FzXQVsVQMhP+blWHKkjmjUDSeK3P
LDC0A3pbSr6gr5JLsCjvgqPYL/kCmyN90AA3Oms32JLYUUTnMxrRdFsj2FxxI1vwm3HGCW2W
GMQMc3vOQ2WQ1cf9gSp2+Gz1n6If3zyoBEreZWEVHXy80I+NTc7MpM0eWi+PNvYNdOpRqvyP
qrwpcnoDE0evYRS90ZTv/JOpjSlSZp/hHMPoUK9FjccgAo6Aobukcd7u9vxWm3z2uLTwFMSK
M6rA6TdB58bXmimK7N8rAgMBAAGjggH/MIIB+zASBgNVHRMBAf8ECDAGAQH/AgEBMA4GA1Ud
DwEB/wQEAwIBBjARBgNVHSAECjAIMAYGBFUdIAAwHQYDVR0OBBYEFNlidIoXi1wWImK8Jw7j
7xqcnLVDMB8GA1UdIwQYMBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5kMB0GA1UdEQQWMBSBEmNh
QHVuaS1rb25zdGFuei5kZTCBiAYDVR0fBIGAMH4wPaA7oDmGN2h0dHA6Ly9jZHAxLnBjYS5k
Zm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NybC9jYWNybC5jcmwwPaA7oDmGN2h0dHA6Ly9j
ZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NybC9jYWNybC5jcmwwgdcGCCsG
AQUFBwEBBIHKMIHHMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1At
U2VydmVyL09DU1AwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFs
LXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEcGCCsGAQUFBzAChjtodHRwOi8vY2Rw
Mi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAy2kzMLxthpOp0TwgEkVWvTS9/BhN9kuYW9qiHVywP5UkEDu5ULEI
SE1X9Bvl9ZUBwZ1iWBchsSAzzal+rcgE7vYNG7QczeXzn2WcuZRbujkt5wB/QRH1I6f0Iafo
nMkTKvPBiprdOvSjjJ3yfSXrcBDMJCKRSMKqfDtqYvTyUITuAnrnKC2VtiTHuw8jibY+ZjMK
bmSqxjBBVJoRs6FcnlR/WO7dBIkIhNzZAr6cdzBxV1Kx9Gb+BrN9/xBsKbuPiCFrmi6py5k3
jpdSpfUpeXmd9TmuzRmibFsw9LwaLJtPx3Ewcge/FOl/yixMk/oanYI+EMr4bCQQwUJkfntC
cjCCBcYwggSuoAMCAQICDB0Blb8I39mLmu56JzANBgkqhkiG9w0BAQsFADBmMQswCQYDVQQG
EwJERTEVMBMGA1UEChMMVW5pLUtvbnN0YW56MR0wGwYDVQQDExRVbmktS29uc3RhbnogQ0Et
UzAwMTEhMB8GCSqGSIb3DQEJARYSY2FAdW5pLWtvbnN0YW56LmRlMB4XDTE3MDQwMzA5Mzg1
NVoXDTE5MDcwOTIzNTkwMFowZzELMAkGA1UEBhMCREUxHjAcBgNVBAoMFVVuaXZlcnNpdGFl
dCBLb25zdGFuejEfMB0GA1UECwwWQmlvbG9naWUgQUcgRGllZGVyaWNoczEXMBUGA1UEAwwO
S2F5IERpZWRlcmljaHMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCnUdTVY3r3
7c6GMPLs5OiILa/Vj23lJMadizd1tfcTksTf4uOi8JbgSrLP3XMY11mxYbLyMlFgOVB6Sa59
Jo2G0dsRavBNnk535TOg/9MHn6EYxVkGbi3Q0YZ6NbC8ntTcMJWN/15OD1vfGoxi8CoGhOxc
RrljHommtPav3LQZZcrQrewgjNx0ENLXn93dj3vwQzP7D7hZNV3U/CeuVMsV0kGojiH+/n5I
hzeSNSria7IfWRoSmdHBCTMWQuU56/Pk+4VC636MwD56YO+NxjPlKCzdNnjE5ib64VmuaOL5
vcp+2kmdegBPuzy0E2caVqjllmY51uEQPmRR0cduByWFAgMBAAGjggJxMIICbTBABgNVHSAE
OTA3MBEGDysGAQQBga0hgiwBAQQDBTARBg8rBgEEAYGtIYIsAgEEAwEwDwYNKwYBBAGBrSGC
LAEBBDAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwHQYDVR0OBBYEFA0Ptfy1mDTHEeMPfD5vdB77QhqJMB8GA1UdIwQYMBaAFNli
dIoXi1wWImK8Jw7j7xqcnLVDMCkGA1UdEQQiMCCBHmtheS5kaWVkZXJpY2hzQHVuaS1rb25z
dGFuei5kZTCBmQYDVR0fBIGRMIGOMEWgQ6BBhj9odHRwOi8vY2RwMS5wY2EuZGZuLmRlL3Vu
aS1rb25zdGFuei1zZXJ2ZXItY2EvcHViL2NybC9jYWNybC5jcmwwRaBDoEGGP2h0dHA6Ly9j
ZHAyLnBjYS5kZm4uZGUvdW5pLWtvbnN0YW56LXNlcnZlci1jYS9wdWIvY3JsL2NhY3JsLmNy
bDCB5wYIKwYBBQUHAQEEgdowgdcwMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4u
ZGUvT0NTUC1TZXJ2ZXIvT0NTUDBPBggrBgEFBQcwAoZDaHR0cDovL2NkcDEucGNhLmRmbi5k
ZS91bmkta29uc3Rhbnotc2VydmVyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBPBggrBgEF
BQcwAoZDaHR0cDovL2NkcDIucGNhLmRmbi5kZS91bmkta29uc3Rhbnotc2VydmVyLWNhL3B1
Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQsFAAOCAQEAYsMtj1n0og6XiOvhC6F0
NsKfGxYeWFyclQHkI8PsuhmAo7VyfJLJuxhfVT5R/bUs6ia0QNbQcS66QUPEWQRMVKPN2ZCE
BR6Vcd1AKS2q80J9i0MCzDH8LKJbfqI2Gq/Z7yNbW8mV5K/plukArIbu8U2zpLSVygq3ZzKB
h5QIvTbrd/QljBhR0DbzeLgBl2OS9qp07f0RwIZ3DRssLuIYn2WOsgGU4kPSJYqJM6iPi74e
h3fPk1r/KDVKig8igrP8FnY9VwNgq5ppie0qTfh3CUEIFap2RwmIILA0cdAMkh//H/QAtVcv
W2eaUYsXcM/E6WdpLuROEOfhCb9b4fV/YzGCA44wggOKAgEBMHYwZjELMAkGA1UEBhMCREUx
FTATBgNVBAoTDFVuaS1Lb25zdGFuejEdMBsGA1UEAxMUVW5pLUtvbnN0YW56IENBLVMwMDEx
ITAfBgkqhkiG9w0BCQEWEmNhQHVuaS1rb25zdGFuei5kZQIMHQGVvwjf2Yua7nonMA0GCWCG
SAFlAwQCAQUAoIIB6TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xODAyMDkyMDUyMzhaMC8GCSqGSIb3DQEJBDEiBCC4cZz7W7U546ZQ4j/wT+wsjohErXyU
n6y92XdnsPVkTTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIw
CgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0G
CCqGSIb3DQMCAgEoMIGFBgkrBgEEAYI3EAQxeDB2MGYxCzAJBgNVBAYTAkRFMRUwEwYDVQQK
EwxVbmktS29uc3RhbnoxHTAbBgNVBAMTFFVuaS1Lb25zdGFueiBDQS1TMDAxMSEwHwYJKoZI
hvcNAQkBFhJjYUB1bmkta29uc3RhbnouZGUCDB0Blb8I39mLmu56JzCBhwYLKoZIhvcNAQkQ
AgsxeKB2MGYxCzAJBgNVBAYTAkRFMRUwEwYDVQQKEwxVbmktS29uc3RhbnoxHTAbBgNVBAMT
FFVuaS1Lb25zdGFueiBDQS1TMDAxMSEwHwYJKoZIhvcNAQkBFhJjYUB1bmkta29uc3Rhbnou
ZGUCDB0Blb8I39mLmu56JzANBgkqhkiG9w0BAQEFAASCAQAXE7tv59GMBvuaoi5uIGBYOeKR
vTyGKv6ocARjN0HDYe1c1+Id+Mg2fp1m8CbKUTnA8mTWFRX/u0WRIq0slLHRcztB7bu7UhHE
1T01wcdfKh8vWxs7TV97HbrTTruS7NQINyhbN98sY855wvTUGotNa4vxXFCFDdSmDtzwMVju
kbBKGP3dKQIOaa1SE6nx4bZmuD5MPoLAu/CcojjVWTb62M7lA23N+eGw3/919kGmIgDVS6OK
PnTsfZWNemMvapbLhbU1gw6j7khEuElD+DMS05+WfPxbnQbAncny2Exjz3P3l3EPGKUceI6b
VkBGaLldzLBaSpa5L4AtCpPPmAIKAAAAAAAA
--------------ms020506020904070701020109--
