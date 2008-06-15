From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: need some help very strange behavior mdadm writes data to non
      raid disk?
Date: Sun, 15 Jun 2008 17:46:38 +0200
Message-ID: <4855395E.2060106@powercraft.nl>
References: <4854E067.5030205@powercraft.nl> <38924.192.168.1.70.1213526332.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070805040107050005010601"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38924.192.168.1.70.1213526332.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070805040107050005010601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

NeilBrown wrote:
> On Sun, June 15, 2008 7:27 pm, Jelle de Jong wrote:
>> This message contains the following attachment(s):
>> debug-mdadm.txt
>> setup-mdadm.txt
>>
>> Dear Neil,
>>
>> Thank you for creating mdadm. I am creating my first raid1 array and got
>> some very confusing issues.
>>
>> My raid1 md0 array should consist out of disks:
>> /dev/sda1
>> /dev/sdb1
>>
>> These are 749GB ext3 partitions in mirroring mode.
>>
>> However when I reboot my system, mdadm tells me everything is fine and
>> is correctly using sda1 and sdb1.
>>
>> But it is not using a 749GB partition, it is using the same partition
>> size as my /dev/sdc1? and when I write a test file to the root dir and
>> then mount /dev/sdc1 the file is there also. So md0 is directly
>> connected with /dev/sdc1. It does not make any sens to me.
>>
>> Can you please look at my debug en setup file that i created and maybe
>> see something that is going wrong?
> 
> 
> It is fairly clear that you are still booting off /dev/sdc1 and that is
> being mounted as the root filesystem.
> You probably need to run "mkinitramfs" or something like that to create
> a new ramfs which mounts /dev/md0 instead of /dev/sdc.
> 
> If you don't know how to do that, trying asking on
>    linux-raid@vger.kernel.org
> 
> NeilBrown
> 

Thank you for your eye opener :-D

I totally overlooked the grub menu file. I know have a working system, I 
removed the /dev/sdc1 and now running on raid array only :-D

Thank for your support.

PS. I attached my complete configuration routine as attachment, if you 
see something wrong/dangerous/advice please notify me.

Kind regards,

Jelle de Jong

--------------070805040107050005010601
Content-Type: text/plain;
 name="set-up - server ashley - mdadm raid.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="set-up - server ashley - mdadm raid.txt"

IyBpbmZvcm1hdGlvbjoKIyBodHRwOi8vd3d3Lmhvd3RvZm9yZ2UuY29tL3NvZnR3YXJlLXJh
aWQxLWdydWItYm9vdC1kZWJpYW4tZXRjaC1wNAoKYXB0LWdldCBpbnN0YWxsIG1kYWRtCgoj
IHN0ZXAgMTogc2V0dXAgcGFydGl0aW9ucyBzaXplcyBvbiB0aGUgZmlyc3QgZGlzawpwYXJ0
ZWQgL2Rldi9zZGEKbWtsYWJlbCBtc2Rvcwpta3BhcnQgcHJpbWFyeSAwIDc0OUdCCm1rcGFy
dCBwcmltYXJ5IDc0OUdCIDc1MEdCCnRvZ2dsZSAxIGJvb3QKcHJpbnQKcXVpdAoKIyBzdGVw
IDI6IGNvcHkgcGFydGl0aW9uIHRhYmxlIGZyb20gc2RhIHRvIHNkYgpzZmRpc2sgLWQgL2Rl
di9zZGEgfCBzZmRpc2sgL2Rldi9zZGIKCiMgc3RlcCAzOiBjcmVhdGUgcmFpZCBtaXJyb3Jp
bmcgc2V0dXAKbWRhZG0gLS1jcmVhdGUgL2Rldi9tZDAgLS1sZXZlbD0xIC0tcmFpZC1kZXZp
Y2VzPTIgL2Rldi9zZGExIC9kZXYvc2RiMQptZGFkbSAtLWNyZWF0ZSAvZGV2L21kMSAtLWxl
dmVsPTEgLS1yYWlkLWRldmljZXM9MiAvZGV2L3NkYTIgL2Rldi9zZGIyCgojIHN0ZXAgNDog
Y3JlYXRlIGZpbGUgc3lzdGVtcyBvbiB0aGUgZmlyc3QgZGlzayBwYXJ0aXRpb25zCm1rZnMu
ZXh0MyAvZGV2L21kMApta3N3YXAgL2Rldi9tZDEKCiMgc3RlcCA1OiBjcmVhdGUgdGhlIG1k
YWRtIGNvbmZpZ3VyYXRpb24gZmlsZQojIG1kYWRtIC0tZGV0YWlsIC0tc2NhbiAtLXZlcmJv
c2UgPiAvZXRjL21kYWRtLmNvbmYKbWRhZG0gLS1kZXRhaWwgLS1zY2FuIC0tdmVyYm9zZSA+
IC9ldGMvbWRhZG0vbWRhZG0uY29uZgpkcGtnLXJlY29uZmlndXJlIG1kYWRtCgojIHN0ZXAg
Njogd2F0Y2ggaG93IHRoZSByZWNvbnN0cnVjdGlvbiBvZiB0aGUgYXJyYXkncwp3YXRjaCBj
YXQgL3Byb2MvbWRzdGF0CgojIHN0ZXAgNzogY2hhbmdlIGZzdGFiCmNhdCA+IC9ldGMvZnN0
YWIgPDwgIkVPRiIKVVVJRD0xMGExMWU0NC1hOTU4LTRkMTQtYWU1Ni1hZGY5YWY3YzVjMjgg
LyAgICAgICAgICAgICAgIHJlaXNlcmZzIG5vdGFpbCAgICAgICAwICAgICAgIDEKVVVJRD04
OTE2MjQyNy0zMDkyLTQ4YWYtOTNmMC05MTIzYTRlMDMxZWEgbm9uZSAgICAgICAgICAgIHN3
YXAgICAgc3cgICAgICAgMCAgICAgICAwCi9kZXYvbWQwICAgICAvbWVkaWEvZGlzayBleHQz
ICAgICAgIGRlZmF1bHRzICAgICAgICAgICAgMCAgICAgICAwCi9kZXYvbWQxICAgICBub25l
ICAgICAgICBzd2FwICAgICAgIHN3ICAgICAgICAgICAgICAgICAgMCAgICAgICAwCnByb2Mg
ICAgICAgICAvcHJvYyAgICAgICBwcm9jICAgICAgIGRlZmF1bHRzICAgICAgICAgICAgMCAg
ICAgICAwCkVPRgoKIyBzdGVwIDg6IGNyZWF0ZSBtb3VudCBkaXJlY3RvcnkgYW5kIG1vdW50
IGRpc2tzCm1rZGlyIC9tZWRpYS9kaXNrCm1vdW50IC1hCnRvdWNoIC9tZWRpYS9kaXNrL3Rl
c3QudHh0CmxzIC1oYWwgL21lZGlhL2Rpc2sKCiMgc3RlcCA4OiByZWJvb3QgdGhlIHN5c3Rl
bSBhbmQgY2hlY2sgcmFpZCBkaXNrIGFyZSBtb3VudGVkCnNodXRkb3duIC1yIG5vdwpscyAt
aGFsIC9tZWRpYS9kaXNrCgojIHN0ZXAgOTogc2V0dXAgYm9vdCBmbGFncyBvbiBkaXNrCnBh
cnRlZCAvZGV2L3NkYwp0b2dnbGUgMSBib290CnByaW50CnF1aXQKCiMgc3RlcCAxMDogY2hh
bmdlIGZzdGFiCmNhdCA+IC9ldGMvZnN0YWIgPDwgIkVPRiIKL2Rldi9tZDAgICAgIC8gICAg
ICAgICAgIGV4dDMgICAgICAgZGVmYXVsdHMgICAgICAgICAgICAwICAgICAgIDEKL2Rldi9t
ZDEgICAgIG5vbmUgICAgICAgIHN3YXAgICAgICAgc3cgICAgICAgICAgICAgICAgICAwICAg
ICAgIDAKcHJvYyAgICAgICAgIC9wcm9jICAgICAgIHByb2MgICAgICAgZGVmYXVsdHMgICAg
ICAgICAgICAwICAgICAgIDAKRU9GCgojIHN0ZXAgMTE6IHNldHVwIGdydWIgdG8gYm9vdCBm
cm9tIHJhaWQgYXJyYXkKZmluZD0nIyBncm9vdD0uKicKcmVwbGFjZT0nIyBncm9vdD0oaGQw
LDApJwpzZWQgLWkgLWUgInMlJGZpbmQlJHJlcGxhY2UlZyIgL2Jvb3QvZ3J1Yi9tZW51Lmxz
dApmaW5kPScjIGtvcHQ9cm9vdD0uKiBybycKcmVwbGFjZT0nIyBrb3B0PXJvb3Q9L2Rldi9z
ZGMxIHJvJwpzZWQgLWkgLWUgInMlJGZpbmQlJHJlcGxhY2UlZyIgL2Jvb3QvZ3J1Yi9tZW51
LmxzdApmaW5kPScjIGRlZm9wdGlvbnM9LionCnJlcGxhY2U9JyMgZGVmb3B0aW9ucz1xdWll
dCBub3Jlc3VtZScKc2VkIC1pIC1lICJzLCRmaW5kLCRyZXBsYWNlLGciIC9ib290L2dydWIv
bWVudS5sc3QKdXBkYXRlLWdydWIKCnVwZGF0ZS1pbml0cmFtZnMgLXUKCiMgc3RlcCAxMjog
aW5zdGFsbCBib290bG9hZGVycyBvbiBkaXNrcwpncnViCnJvb3QgKGhkMCwwKQpzZXR1cCAo
aGQwKQpyb290IChoZDEsMCkKc2V0dXAgKGhkMSkKcm9vdCAoaGQyLDApCnNldHVwIChoZDIp
CnF1aXQKCiMgc3RlcCAxMzogY2hhbmdlIHRvIHJ1bmxldmVsIDEgdG8gcHJlcGFyZSBmb3Ig
Y29weWluZwppbml0IDEKCiMgc3RlcCAxNDogY29weSByb290IGRpcmVjdG9yeQpyc3luYyAt
YXF4UCAvIC9tZWRpYS9kaXNrCiMgY3AgLWF4IC8gL21lZGlhL2Rpc2sKCiMgc3RlcCAxNTog
cmVib290IHRoZSBzeXN0ZW0Kc2h1dGRvd24gLXIgbm93CgotLSAtLSAtLSAtLQoKIyBub3Rl
czoKdHVuZTJmcyAtagpzZmRpc2sgLWQgL2Rldi9zZGIgPiBwYXJ0aXRpb25zLnNkYgpzZmRp
c2sgL2Rldi9zZGIgPCBwYXJ0aXRpb25zLnNkYgoKbWRhZG0gLVMgL2Rldi9tZDAKbWRhZG0g
LVMgL2Rldi9tZDEKbWRhZG0gLVMgL2Rldi9tZDIKCm1kYWRtIC9kZXYvbWQwIC0tZmFpbCAv
ZGV2L3NkYTEgLS1yZW1vdmUgL2Rldi9zZGExCm1kYWRtIC9kZXYvbWQxIC0tZmFpbCAvZGV2
L3NkYTIgLS1yZW1vdmUgL2Rldi9zZGEyCm1kYWRtIC9kZXYvbWQyIC0tZmFpbCAvZGV2L3Nk
YTMgLS1yZW1vdmUgL2Rldi9zZGEzCgptZGFkbSAvZGV2L21kMCAtLWZhaWwgL2Rldi9zZGIx
IC0tcmVtb3ZlIC9kZXYvc2RiMQptZGFkbSAvZGV2L21kMSAtLWZhaWwgL2Rldi9zZGIyIC0t
cmVtb3ZlIC9kZXYvc2RiMgptZGFkbSAvZGV2L21kMiAtLWZhaWwgL2Rldi9zZGIzIC0tcmVt
b3ZlIC9kZXYvc2RiMwoKbWRhZG0gLS16ZXJvLXN1cGVyYmxvY2sgL2Rldi9zZGIxCm1kYWRt
IC0temVyby1zdXBlcmJsb2NrIC9kZXYvc2RiMgptZGFkbSAtLXplcm8tc3VwZXJibG9jayAv
ZGV2L3NkYjMK
--------------070805040107050005010601--
