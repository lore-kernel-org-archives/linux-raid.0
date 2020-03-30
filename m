From: Alexander Shenkin <al@shenkin.org>
Subject: Re: Raid-6 won't boot
Date: Mon, 30 Mar 2020 21:05:03 +0100
Message-ID: <740b37a3-83fa-a03f-c253-785bb286cefc@shenkin.org>
References: <7ce3a1b9-7b24-4666-860a-4c4b9325f671@shenkin.org>
 <3868d184-5e65-02e1-618a-2afeb7a80bab@youngman.org.uk>
 <ccab6f84-aab3-f483-e473-64d95cbeb7cc@shenkin.org>
 <CAAMCDee6TcJ_wR6rkQw5V02KyqPQ+xDf+bK+pQPbbfaptO_Tvg@mail.gmail.com>
 <1f393884-dc48-c03e-f734-f9880d9eed96@shenkin.org>
 <CAAMCDedj7TQAAGzSfQgAftKSmrjNmzHgQUs-X2mQZyFPG62_-A@mail.gmail.com>
 <c8185f80-837e-9654-ee19-611a030a0d54@shenkin.org>
 <CAAMCDefr2FakGTz5ok-qvTZiDNTj87vQSWP9ynM_bxtnB=-fkw@mail.gmail.com>
 <fa7e9b6d-28f3-8c9f-0901-eeac761e382f@shenkin.org>
 <CAAMCDefXygV4CZdxadfRFAV+HeEqnY8nWG1hpsVi4tBf1PYYww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9E46969FD00FD09420421B54"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDefXygV4CZdxadfRFAV+HeEqnY8nWG1hpsVi4tBf1PYYww@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: antlists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------9E46969FD00FD09420421B54
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

See attached.  I should mention that the last drive i added is on a new
controller that is separate from the other drives, but seemed to work
fine for a bit, so kinda doubt that's the issue...

thanks,

allie

On 3/30/2020 6:21 PM, Roger Heflin wrote:
> do this against each partition that had it:
>
>  mdadm --examine /dev/sd***
>
> It seems like it is not seeing it as a md-raid.
>
> On Mon, Mar 30, 2020 at 11:13 AM Alexander Shenkin <al@shenkin.org> wrote:
>> Thanks Roger,
>>
>> The only line that isn't commented out in /etc/mdadm.conf is "DEVICE
>> partitions"...
>>
>> Thanks,
>>
>> Allie
>>
>> On 3/30/2020 4:53 PM, Roger Heflin wrote:
>>> That seems really odd.  Is the raid456 module loaded?
>>>
>>> On mine I see messages like this for each disk it scanned and
>>> considered as maybe possibly being an array member.
>>>  kernel: [   83.468700] md/raid:md13: device sdi3 operational as raid disk 5
>>> and messages like this:
>>>  md/raid:md14: not clean -- starting background reconstruction
>>>
>>> You might look at /etc/mdadm.conf on the rescue cd and see if it has a
>>> DEVICE line that limits what is being scanned.
>>>
>>> On Mon, Mar 30, 2020 at 10:13 AM Alexander Shenkin <al@shenkin.org> wrote:
>>>> Thanks Roger,
>>>>
>>>> that grep just returns the detection of the raid1 (md127).  See dmesg
>>>> and mdadm --detail results attached.
>>>>
>>>> Many thanks,
>>>> allie
>>>>
>>>> On 3/28/2020 1:36 PM, Roger Heflin wrote:
>>>>> Try this grep:
>>>>> dmesg | grep "md/raid", if that returns nothing if you can just send
>>>>> the entire dmesg.
>>>>>
>>>>> On Sat, Mar 28, 2020 at 2:47 AM Alexander Shenkin <al@shenkin.org> wrote:
>>>>>> Thanks Roger.  dmesg has nothing in it referring to md126 or md127....
>>>>>> any other thoughts on how to investigate?
>>>>>>
>>>>>> thanks,
>>>>>> allie
>>>>>>
>>>>>> On 3/27/2020 3:55 PM, Roger Heflin wrote:
>>>>>>> A non-assembled array always reports raid1.
>>>>>>>
>>>>>>> I would run "dmesg | grep md126" to start with and see what it reports it saw.
>>>>>>>
>>>>>>> On Fri, Mar 27, 2020 at 10:29 AM Alexander Shenkin <al@shenkin.org> wrote:
>>>>>>>> Thanks Wol,
>>>>>>>>
>>>>>>>> Booting in SystemRescueCD and looking in /proc/mdstat, two arrays are
>>>>>>>> reported.  The first (md126) in reported as inactive with all 7 disks
>>>>>>>> listed as spares.  The second (md127) is reported as active
>>>>>>>> auto-read-only with all 7 disks operational.  Also, the only
>>>>>>>> "personality" reported is Raid1.  I could go ahead with your suggestion
>>>>>>>> of mdadm --stop array and then mdadm --assemble, but I thought the
>>>>>>>> reporting of just the Raid1 personality was a bit strange, so wanted to
>>>>>>>> check in before doing that...
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Allie
>>>>>>>>
>>>>>>>> On 3/26/2020 10:00 PM, antlists wrote:
>>>>>>>>> On 26/03/2020 17:07, Alexander Shenkin wrote:
>>>>>>>>>> I surely need to boot with a rescue disk of some sort, but from there,
>>>>>>>>>> I'm not sure exactly when I should do.  Any suggestions are very welcome!
>>>>>>>>> Okay. Find a liveCD that supports raid (hopefully something like
>>>>>>>>> SystemRescueCD). Make sure it has a very recent kernel and the latest
>>>>>>>>> mdadm.
>>>>>>>>>
>>>>>>>>> All being well, the resync will restart, and when it's finished your
>>>>>>>>> system will be fine. If it doesn't restart on its own, do an "mdadm
>>>>>>>>> --stop array", followed by an "mdadm --assemble"
>>>>>>>>>
>>>>>>>>> If that doesn't work, then
>>>>>>>>>
>>>>>>>>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>>>>>>>>>
>>>>>>>>> Cheers,
>>>>>>>>> Wol

--------------9E46969FD00FD09420421B54
Content-Type: text/plain; charset=UTF-8;
 name="sda3.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sda3.txt"

L2Rldi9zZGEzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IGM3MzAzZjYy
OmQ4NDhkNDI0OjI2OTU4MWM4OjgzYTA0NWVjCiAgICAgICAgICAgTmFtZSA6IHVidW50dToy
CiAgQ3JlYXRpb24gVGltZSA6IFN1biBGZWIgIDUgMjM6Mzk6NTggMjAxNwogICAgIFJhaWQg
TGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA1
ODQwMzc3ODU2ICgyNzg0LjkxIEdpQiAyOTkwLjI3IEdCKQogICAgIEFycmF5IFNpemUgOiAx
NDYwMDk0NDY0MCAoMTM5MjQuNTUgR2lCIDE0OTUxLjM3IEdCKQogICAgRGF0YSBPZmZzZXQg
OiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2Vk
IFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0wIHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogYWN0aXZlCiAgICBEZXZpY2UgVVVJRCA6IDEwYmRiZWQ1OmNiNzBjOGE5
OjU2NmMzODRkOmVjNGM5MjZlCgpJbnRlcm5hbCBCaXRtYXAgOiA4IHNlY3RvcnMgZnJvbSBz
dXBlcmJsb2NrCiAgUmVzaGFwZSBwb3MnbiA6IDAKICBEZWx0YSBEZXZpY2VzIDogMSAoNi0+
NykKCiAgICBVcGRhdGUgVGltZSA6IFR1ZSBGZWIgMjUgMDk6MjE6MjcgMjAyMAogIEJhZCBC
bG9jayBMb2cgOiA1MTIgZW50cmllcyBhdmFpbGFibGUgYXQgb2Zmc2V0IDcyIHNlY3RvcnMK
ICAgICAgIENoZWNrc3VtIDogMzAwZjY5NDUgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6
IDMxNjQ4NQoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBT
aXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDAKICAgQXJyYXkg
U3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09
IHJlcGxhY2luZykK
--------------9E46969FD00FD09420421B54
Content-Type: text/plain; charset=UTF-8;
 name="sdb3.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sdb3.txt"

L2Rldi9zZGIzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IGM3MzAzZjYy
OmQ4NDhkNDI0OjI2OTU4MWM4OjgzYTA0NWVjCiAgICAgICAgICAgTmFtZSA6IHVidW50dToy
CiAgQ3JlYXRpb24gVGltZSA6IFN1biBGZWIgIDUgMjM6Mzk6NTggMjAxNwogICAgIFJhaWQg
TGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA1
ODQwMzc3ODU2ICgyNzg0LjkxIEdpQiAyOTkwLjI3IEdCKQogICAgIEFycmF5IFNpemUgOiAx
NDYwMDk0NDY0MCAoMTM5MjQuNTUgR2lCIDE0OTUxLjM3IEdCKQogICAgRGF0YSBPZmZzZXQg
OiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2Vk
IFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0wIHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogYWN0aXZlCiAgICBEZXZpY2UgVVVJRCA6IGNmNzBkYWQ1OjBjOWZmNWY2
OmVkZTY4OWYyOmNjZWUyZWIwCgpJbnRlcm5hbCBCaXRtYXAgOiA4IHNlY3RvcnMgZnJvbSBz
dXBlcmJsb2NrCiAgUmVzaGFwZSBwb3MnbiA6IDAKICBEZWx0YSBEZXZpY2VzIDogMSAoNi0+
NykKCiAgICBVcGRhdGUgVGltZSA6IFR1ZSBGZWIgMjUgMDk6MjE6MjcgMjAyMAogIEJhZCBC
bG9jayBMb2cgOiA1MTIgZW50cmllcyBhdmFpbGFibGUgYXQgb2Zmc2V0IDcyIHNlY3RvcnMK
ICAgICAgIENoZWNrc3VtIDogNjQ0NjY3YmIgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6
IDMxNjQ4NQoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBT
aXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDEKICAgQXJyYXkg
U3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09
IHJlcGxhY2luZykK
--------------9E46969FD00FD09420421B54
Content-Type: text/plain; charset=UTF-8;
 name="sdc3.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sdc3.txt"

L2Rldi9zZGMzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IGM3MzAzZjYy
OmQ4NDhkNDI0OjI2OTU4MWM4OjgzYTA0NWVjCiAgICAgICAgICAgTmFtZSA6IHVidW50dToy
CiAgQ3JlYXRpb24gVGltZSA6IFN1biBGZWIgIDUgMjM6Mzk6NTggMjAxNwogICAgIFJhaWQg
TGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA1
ODQwMzc3ODU2ICgyNzg0LjkxIEdpQiAyOTkwLjI3IEdCKQogICAgIEFycmF5IFNpemUgOiAx
NDYwMDk0NDY0MCAoMTM5MjQuNTUgR2lCIDE0OTUxLjM3IEdCKQogICAgRGF0YSBPZmZzZXQg
OiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2Vk
IFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0wIHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogYWN0aXZlCiAgICBEZXZpY2UgVVVJRCA6IGY4ODM5OTUyOmVhYmEyZTlj
OmMyYzQwMWQ0OjNlMDU5MmE1CgpJbnRlcm5hbCBCaXRtYXAgOiA4IHNlY3RvcnMgZnJvbSBz
dXBlcmJsb2NrCiAgUmVzaGFwZSBwb3MnbiA6IDAKICBEZWx0YSBEZXZpY2VzIDogMSAoNi0+
NykKCiAgICBVcGRhdGUgVGltZSA6IFR1ZSBGZWIgMjUgMDk6MjE6MjcgMjAyMAogIEJhZCBC
bG9jayBMb2cgOiA1MTIgZW50cmllcyBhdmFpbGFibGUgYXQgb2Zmc2V0IDcyIHNlY3RvcnMK
ICAgICAgIENoZWNrc3VtIDogNWQxOThiMDYgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6
IDMxNjQ4NQoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBT
aXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDIKICAgQXJyYXkg
U3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09
IHJlcGxhY2luZykK
--------------9E46969FD00FD09420421B54
Content-Type: text/plain; charset=UTF-8;
 name="sdd3.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sdd3.txt"

L2Rldi9zZGQzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IGM3MzAzZjYy
OmQ4NDhkNDI0OjI2OTU4MWM4OjgzYTA0NWVjCiAgICAgICAgICAgTmFtZSA6IHVidW50dToy
CiAgQ3JlYXRpb24gVGltZSA6IFN1biBGZWIgIDUgMjM6Mzk6NTggMjAxNwogICAgIFJhaWQg
TGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA1
ODQwMzc3ODU2ICgyNzg0LjkxIEdpQiAyOTkwLjI3IEdCKQogICAgIEFycmF5IFNpemUgOiAx
NDYwMDk0NDY0MCAoMTM5MjQuNTUgR2lCIDE0OTUxLjM3IEdCKQogICAgRGF0YSBPZmZzZXQg
OiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2Vk
IFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0wIHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogYWN0aXZlCiAgICBEZXZpY2UgVVVJRCA6IDg3NWEwZGJkOjk2NWE5OTg2
OjFiNzhlYjNkOmUxNWZlZTUwCgpJbnRlcm5hbCBCaXRtYXAgOiA4IHNlY3RvcnMgZnJvbSBz
dXBlcmJsb2NrCiAgUmVzaGFwZSBwb3MnbiA6IDAKICBEZWx0YSBEZXZpY2VzIDogMSAoNi0+
NykKCiAgICBVcGRhdGUgVGltZSA6IFR1ZSBGZWIgMjUgMDk6MjE6MjcgMjAyMAogIEJhZCBC
bG9jayBMb2cgOiA1MTIgZW50cmllcyBhdmFpbGFibGUgYXQgb2Zmc2V0IDcyIHNlY3RvcnMK
ICAgICAgIENoZWNrc3VtIDogYzczZTBmM2YgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6
IDMxNjQ4NQoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBT
aXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDMKICAgQXJyYXkg
U3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09
IHJlcGxhY2luZykK
--------------9E46969FD00FD09420421B54
Content-Type: text/plain; charset=UTF-8;
 name="sde3.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sde3.txt"

L2Rldi9zZGUzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IGM3MzAzZjYy
OmQ4NDhkNDI0OjI2OTU4MWM4OjgzYTA0NWVjCiAgICAgICAgICAgTmFtZSA6IHVidW50dToy
CiAgQ3JlYXRpb24gVGltZSA6IFN1biBGZWIgIDUgMjM6Mzk6NTggMjAxNwogICAgIFJhaWQg
TGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA1
ODQwMzc3ODU2ICgyNzg0LjkxIEdpQiAyOTkwLjI3IEdCKQogICAgIEFycmF5IFNpemUgOiAx
NDYwMDk0NDY0MCAoMTM5MjQuNTUgR2lCIDE0OTUxLjM3IEdCKQogICAgRGF0YSBPZmZzZXQg
OiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2Vk
IFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0wIHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogYWN0aXZlCiAgICBEZXZpY2UgVVVJRCA6IDYzNWVmNzFiOmU0YWRkOTI1
OjMwYWU0ZjBhOmY2YjQ2NjExCgpJbnRlcm5hbCBCaXRtYXAgOiA4IHNlY3RvcnMgZnJvbSBz
dXBlcmJsb2NrCiAgUmVzaGFwZSBwb3MnbiA6IDAKICBEZWx0YSBEZXZpY2VzIDogMSAoNi0+
NykKCiAgICBVcGRhdGUgVGltZSA6IFR1ZSBGZWIgMjUgMDk6MjE6MjcgMjAyMAogIEJhZCBC
bG9jayBMb2cgOiA1MTIgZW50cmllcyBhdmFpbGFibGUgYXQgb2Zmc2V0IDcyIHNlY3RvcnMK
ICAgICAgIENoZWNrc3VtIDogNTI0NGYxOTYgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6
IDMxNjQ4NQoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBT
aXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDYKICAgQXJyYXkg
U3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09
IHJlcGxhY2luZykK
--------------9E46969FD00FD09420421B54
Content-Type: text/plain; charset=UTF-8;
 name="sdf3.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sdf3.txt"

L2Rldi9zZGYzOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IGM3MzAzZjYy
OmQ4NDhkNDI0OjI2OTU4MWM4OjgzYTA0NWVjCiAgICAgICAgICAgTmFtZSA6IHVidW50dToy
CiAgQ3JlYXRpb24gVGltZSA6IFN1biBGZWIgIDUgMjM6Mzk6NTggMjAxNwogICAgIFJhaWQg
TGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA1
ODQwMzc3ODU2ICgyNzg0LjkxIEdpQiAyOTkwLjI3IEdCKQogICAgIEFycmF5IFNpemUgOiAx
NDYwMDk0NDY0MCAoMTM5MjQuNTUgR2lCIDE0OTUxLjM3IEdCKQogICAgRGF0YSBPZmZzZXQg
OiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2Vk
IFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0wIHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogYWN0aXZlCiAgICBEZXZpY2UgVVVJRCA6IGRjMGJkYThjOjI0NTdmYjRj
OmY4N2E0YmVjOjhkNWI1OGVkCgpJbnRlcm5hbCBCaXRtYXAgOiA4IHNlY3RvcnMgZnJvbSBz
dXBlcmJsb2NrCiAgUmVzaGFwZSBwb3MnbiA6IDAKICBEZWx0YSBEZXZpY2VzIDogMSAoNi0+
NykKCiAgICBVcGRhdGUgVGltZSA6IFR1ZSBGZWIgMjUgMDk6MjE6MjcgMjAyMAogIEJhZCBC
bG9jayBMb2cgOiA1MTIgZW50cmllcyBhdmFpbGFibGUgYXQgb2Zmc2V0IDcyIHNlY3RvcnMK
ICAgICAgIENoZWNrc3VtIDogYTgzNmJiYWUgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6
IDMxNjQ4NQoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBT
aXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDUKICAgQXJyYXkg
U3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09
IHJlcGxhY2luZykK
--------------9E46969FD00FD09420421B54
Content-Type: text/plain; charset=UTF-8;
 name="sdg3.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sdg3.txt"

L2Rldi9zZGczOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24g
OiAxLjIKICAgIEZlYXR1cmUgTWFwIDogMHg1CiAgICAgQXJyYXkgVVVJRCA6IGM3MzAzZjYy
OmQ4NDhkNDI0OjI2OTU4MWM4OjgzYTA0NWVjCiAgICAgICAgICAgTmFtZSA6IHVidW50dToy
CiAgQ3JlYXRpb24gVGltZSA6IFN1biBGZWIgIDUgMjM6Mzk6NTggMjAxNwogICAgIFJhaWQg
TGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA3CgogQXZhaWwgRGV2IFNpemUgOiA1
ODQwMzc3ODU2ICgyNzg0LjkxIEdpQiAyOTkwLjI3IEdCKQogICAgIEFycmF5IFNpemUgOiAx
NDYwMDk0NDY0MCAoMTM5MjQuNTUgR2lCIDE0OTUxLjM3IEdCKQogICAgRGF0YSBPZmZzZXQg
OiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgVW51c2Vk
IFNwYWNlIDogYmVmb3JlPTI2MjA1NiBzZWN0b3JzLCBhZnRlcj0wIHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogYWN0aXZlCiAgICBEZXZpY2UgVVVJRCA6IGRjODQyZGMzOjA5YzkxMGM3
OmMzNTFjMzA3OmUyMzgzZDEzCgpJbnRlcm5hbCBCaXRtYXAgOiA4IHNlY3RvcnMgZnJvbSBz
dXBlcmJsb2NrCiAgUmVzaGFwZSBwb3MnbiA6IDAKICBEZWx0YSBEZXZpY2VzIDogMSAoNi0+
NykKCiAgICBVcGRhdGUgVGltZSA6IFR1ZSBGZWIgMjUgMDk6MjE6MjcgMjAyMAogIEJhZCBC
bG9jayBMb2cgOiA1MTIgZW50cmllcyBhdmFpbGFibGUgYXQgb2Zmc2V0IDcyIHNlY3RvcnMK
ICAgICAgIENoZWNrc3VtIDogOTlmYzVhYjMgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6
IDMxNjQ4NQoKICAgICAgICAgTGF5b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBT
aXplIDogNTEySwoKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDQKICAgQXJyYXkg
U3RhdGUgOiBBQUFBQUFBICgnQScgPT0gYWN0aXZlLCAnLicgPT0gbWlzc2luZywgJ1InID09
IHJlcGxhY2luZykK
--------------9E46969FD00FD09420421B54--
