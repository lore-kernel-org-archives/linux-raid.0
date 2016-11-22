From: "theelectricengineer@gmail.com" <theelectricengineer@gmail.com>
Subject: Re:Please help RAID1 complete fail no superblock
Date: Tue, 22 Nov 2016 16:24:25 +0000
Message-ID: <856401.507833169-sendEmail@optimum>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----MIME delimiter for sendEmail-458818.844360398"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format. To properly display this message you need a MIME-Version 1.0 compliant Email program.

------MIME delimiter for sendEmail-458818.844360398
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

>On 22/11/16 14:49, George Rapp wrote:
>> On Tue, Nov 22, 2016 at 9:31 AM, theelectricengineer@gmail.com
>> <theelectricengineer@gmail.com> wrote:
>>> Hello good people of the linux-raid group,
>>>
>>> I really need your help with my RAID1 that has completely failed, on which I have photos of my beloved deceased grandparents.
>>>
>>> I had the RAID1 array for about 3 years, and I had replaced one of the drives when it failed about one year ago. All worked fine.
>>>
>>> A few weeks ago, I bought a new computer and wanted to move the array to the new computer.
>>> I read several guides, and thought that all I had to do was turn both computers off, move the drives, and in the new computer execute: mdadm --assemble --scan
>>> which I did.
>>>
>>> The output was: mdadm: /dev/sdb has no superblock - assembly aborted
>>>
>>> I panicked, moved the drives back, but the old RAID wouldn't start!
>>> The old computer too says that one of the drives has no superblock
>>> and, even worse, that the other is UNALLOCATED SPACE!!!
>>>
>>> I don't understand why the partition on the second drive disappeared, and I'm so worried.
>>>
>>> PLEASE, PLEASE help me...
>>>
>>> I read the wiki pages (raid wiki kernel), but I'm afraid to run any commands that might make things worse.
>>>
>>> I would be very happy if I could restore the data from either one of the drives,
>>> and copy it to the new drives in my new computer (as I should have done before moving the drives).
>>>
>>
>> Yaniv -
>>
>> One more piece of information that would be helpful is the partition
>> tables for each drive:
>>
>> # fdisk -l /dev/sdb /dev/sdc
>>
> 
> And search the archive for the following thread - "RAID10 with 2 drives
> auto-assembled as RAID1". It's pretty recent.
> 
> You've got a mirror, which means both of your drives should have a valid
> filesystem on them, so things look optimistic. It's just a case of
> finding it - that thread should help you look. The experts will chime
> in, but if you can find the string sequences they're looking for, it'll
> help you recover the partition(s). What filesystem were you using?
> 
> Cheers,
> Wol


Thank you both for the quick response,

Attached are the outputs of fdisk -l for both drives.

I read the correspondence in the archived email thread "RAID10 with 2 drives
auto-assembled as RAID1",
but I don't understand what I should do.

Could you please guide me?
I'm afraid to execute any unfamiliar commands that might lower my chances of saving my data.

Thank you so much!

Yaniv


------MIME delimiter for sendEmail-458818.844360398
Content-Type: text/plain;
        name="fdisk_l_sdb.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="fdisk_l_sdb.txt"

V0FSTklORzogR1BUIChHVUlEIFBhcnRpdGlvbiBUYWJsZSkgZGV0ZWN0ZWQgb24gJy9kZXYvc2Ri
JyEgVGhlIHV0aWwgZmRpc2sgZG9lc24ndCBzdXBwb3J0IEdQVC4gVXNlIEdOVSBQYXJ0ZWQuCgoK
RGlzayAvZGV2L3NkYjogMzAwMC42IEdCLCAzMDAwNTkyOTgyMDE2IGJ5dGVzCjI1NSBoZWFkcywg
NjMgc2VjdG9ycy90cmFjaywgMzY0ODAxIGN5bGluZGVycywgdG90YWwgNTg2MDUzMzE2OCBzZWN0
b3JzClVuaXRzID0gc2VjdG9ycyBvZiAxICogNTEyID0gNTEyIGJ5dGVzClNlY3RvciBzaXplIChs
b2dpY2FsL3BoeXNpY2FsKTogNTEyIGJ5dGVzIC8gNDA5NiBieXRlcwpJL08gc2l6ZSAobWluaW11
bS9vcHRpbWFsKTogNDA5NiBieXRlcyAvIDQwOTYgYnl0ZXMKRGlzayBpZGVudGlmaWVyOiAweDA4
N2MxMzU1CgogICBEZXZpY2UgQm9vdCAgICAgIFN0YXJ0ICAgICAgICAgRW5kICAgICAgQmxvY2tz
ICAgSWQgIFN5c3RlbQovZGV2L3NkYjEgICAgICAgICAgICAgICAxICA0Mjk0OTY3Mjk1ICAyMTQ3
NDgzNjQ3KyAgZWUgIEdQVApQYXJ0aXRpb24gMSBkb2VzIG5vdCBzdGFydCBvbiBwaHlzaWNhbCBz
ZWN0b3IgYm91bmRhcnkuCg==

------MIME delimiter for sendEmail-458818.844360398
Content-Type: text/plain;
        name="fdisk_l_sdc.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="fdisk_l_sdc.txt"

V0FSTklORzogR1BUIChHVUlEIFBhcnRpdGlvbiBUYWJsZSkgZGV0ZWN0ZWQgb24gJy9kZXYvc2Rj
JyEgVGhlIHV0aWwgZmRpc2sgZG9lc24ndCBzdXBwb3J0IEdQVC4gVXNlIEdOVSBQYXJ0ZWQuCgoK
RGlzayAvZGV2L3NkYzogMzAwMC42IEdCLCAzMDAwNTkyOTgyMDE2IGJ5dGVzCjI1NiBoZWFkcywg
NjMgc2VjdG9ycy90cmFjaywgMzYzMzc2IGN5bGluZGVycywgdG90YWwgNTg2MDUzMzE2OCBzZWN0
b3JzClVuaXRzID0gc2VjdG9ycyBvZiAxICogNTEyID0gNTEyIGJ5dGVzClNlY3RvciBzaXplIChs
b2dpY2FsL3BoeXNpY2FsKTogNTEyIGJ5dGVzIC8gNDA5NiBieXRlcwpJL08gc2l6ZSAobWluaW11
bS9vcHRpbWFsKTogNDA5NiBieXRlcyAvIDQwOTYgYnl0ZXMKRGlzayBpZGVudGlmaWVyOiAweDAw
MDAwMDAwCgogICBEZXZpY2UgQm9vdCAgICAgIFN0YXJ0ICAgICAgICAgRW5kICAgICAgQmxvY2tz
ICAgSWQgIFN5c3RlbQovZGV2L3NkYzEgICAgICAgICAgICAgICAxICA0Mjk0OTY3Mjk1ICAyMTQ3
NDgzNjQ3KyAgZWUgIEdQVApQYXJ0aXRpb24gMSBkb2VzIG5vdCBzdGFydCBvbiBwaHlzaWNhbCBz
ZWN0b3IgYm91bmRhcnkuCg==

------MIME delimiter for sendEmail-458818.844360398--

