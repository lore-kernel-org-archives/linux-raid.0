Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F060F20E0
	for <linux-raid@vger.kernel.org>; Tue,  2 Jan 2024 02:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4T3y9c45hfz4f3nqG
	for <linux-raid@vger.kernel.org>; Tue,  2 Jan 2024 10:54:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C66811A017D
	for <linux-raid@vger.kernel.org>; Tue,  2 Jan 2024 10:54:15 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgCnqxHWepNlZOQiFQ--.29632S3;
	Tue, 02 Jan 2024 10:54:15 +0800 (CST)
Subject: Re: RAID1 write-mostly+write-behind lockup bug, reproduced under
 6.7-rc5
To: Alexey Klimov <alexey.klimov@linaro.org>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, klimov.linux@gmail.com,
 Mathieu Poirier <mathieu.poirier@linaro.org>, "yukuai (C)"
 <yukuai3@huawei.com>
References: <CANgGJDrUELtNokv2T45RzaUr_8M8BYPr-AXJ2tpTk9umdK90+Q@mail.gmail.com>
 <da99b77d-61fc-b454-30b6-bf20d536277f@huaweicloud.com>
 <CANgGJDpsrjbTPDtt7xhDEfx0uheHLo98QsNSFa7Pqbghri4mfg@mail.gmail.com>
 <0d4558cb-0836-e0dd-d100-a1fa11cec74b@huaweicloud.com>
 <CANgGJDrTq0J7Yf49xwspeWBsdVBgbrU7zkJ+-CPy==heFSN1Mg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3f960a46-082e-8945-1118-649fc6918228@huaweicloud.com>
Date: Tue, 2 Jan 2024 10:54:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CANgGJDrTq0J7Yf49xwspeWBsdVBgbrU7zkJ+-CPy==heFSN1Mg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------F0B8CD6D8E42720DACD5EE3B"
X-CM-TRANSID:cCh0CgCnqxHWepNlZOQiFQ--.29632S3
X-Coremail-Antispam: 1UD129KBjvJXoWxArWrWr4UXF18Wr1DGF45Wrg_yoWrKr13pF
	WUJ3W3tws7Gr17G3ZFvw1kWryUtayDArZxXFnxX34rKrn0kFySqr4xtrs09FnFvrsIkw1I
	vrZ8Xry3Zr1vyw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wASzI0EjI02j7AqF2xKxwAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l
	FcxC0VAYjxAxZF0Ex2IqxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v2
	0xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r1j6r4UMVCEFcxC0VAYjxAxZFUvcSsGvfC2KfnxnUUI43ZEXa7VUbmLvtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

This is a multi-part message in MIME format.
--------------F0B8CD6D8E42720DACD5EE3B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

在 2023/12/30 9:27, Alexey Klimov 写道:
> On Thu, 28 Dec 2023 at 12:09, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/12/28 12:19, Alexey Klimov 写道:
>>> On Thu, 14 Dec 2023 at 01:34, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> 在 2023/12/14 7:48, Alexey Klimov 写道:
>>>>> Hi all,
>>>>>
>>>>> After assembling raid1 consisting from two NVMe disks/partitions where
>>>>> one of the NVMes is slower than the other one using such command:
>>>>> mdadm --homehost=any --create --verbose --level=1 --metadata=1.2
>>>>> --raid-devices=2 /dev/md77 /dev/nvme2n1p9 --bitmap=internal
>>>>> --write-mostly --write-behind=8192 /dev/nvme1n1p2
>>>>>
>>>>> I noticed some I/O freezing/lockup issues when doing distro builds
>>>>> using yocto. The idea of building write-mostly raid1 came from URL
>>>>> [0]. I suspected that massive and long IO operations led to that and
>>>>> while trying to narrow it down I can see that it doesn't survive
>>>>> through rebuilding linux kernel (just simple make -j33).
>>>>>
>>>>> After enabling some lock checks in kernel and lockup detectors I think
>>>>> this is the main blocked task message:
>>>>>
>>>>> [  984.138650] INFO: task kworker/u65:5:288 blocked for more than 491 seconds.
>>>>> [  984.138682]       Not tainted 6.7.0-rc5-00047-g5bd7ef53ffe5 #1
>>>>> [  984.138694] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>>> disables this message.
>>>>> [  984.138702] task:kworker/u65:5   state:D stack:0     pid:288
>>>>> tgid:288   ppid:2      flags:0x00004000
>>>>> [  984.138728] Workqueue: writeback wb_workfn (flush-9:77)
>>>>> [  984.138760] Call Trace:
>>>>> [  984.138770]  <TASK>
>>>>> [  984.138785]  __schedule+0x3a5/0x1600
>>>>> [  984.138807]  ? schedule+0x99/0x120
>>>>> [  984.138818]  ? find_held_lock+0x2b/0x80
>>>>> [  984.138840]  schedule+0x48/0x120
>>>>> [  984.138851]  ? schedule+0x99/0x120
>>>>> [  984.138861]  wait_for_serialization+0xd2/0x110
>>>>
>>>> This is waiting for issued IO to be done, from
>>>> raid1_end_write_request
>>>>     remove_serial
>>>>      raid1_rb_remove
>>>>      wake_up
>>>
>>> Yep, looks like this.
>>>
>>>> So the first thing need clarification is that is there unfinished IO
>>>> from underlying disk? This is not easy, but perhaps you can try:
>>>>
>>>> 1) don't use the underlying disks by anyone else;
>>>> 2) reporduce the problem, and then collect debugfs info for underlying
>>>> disks with following cmd:
>>>>
>>>> find /sys/kernel/debug/block/sda/ -type f | xargs grep .
>>>
>>> I collected this and attaching to this email.
>>> When I collected this debug data I also noticed the following inflight counters:
>>> root@tux:/sys/devices/virtual/block/md77# cat inflight
>>>          0       65
>>> root@tux:/sys/devices/virtual/block/md77# cat slaves/nvme1n1p2/inflight
>>>          0        0
>>> root@tux:/sys/devices/virtual/block/md77# cat slaves/nvme2n1p9/inflight
>>>          0        0
>>>
>>> So I guess on the md or raid1 level there are 65 write requests that
>>> didn't finish but nothing from underlying physical devices, right?
>>
>> Actually, IOs stuck in wait_for_serialization() are accounted by
>> inflight from md77.
> 
> Do you think ftracing mdXY_raid1 kernel thread with function plugin will help?
> 
>> However, since there are no IO from nvme disks, looks like something is
>> wrong with write behind.
>>
>>>
>>> Apart from that. When the lockup/freeze happens I can mount other
>>> partitions on the corresponding nvme devices and create files there.
>>> nvme-cli util also don't show any issues AFAICS.
>>>
>>> When I manually set backlog file to zero:
>>> echo 0 > /sys/devices/virtual/block/md77/md/bitmap/backlog
>>> the lockup is no longer reproducible.
>>
>> Of course, this disables write behind, which also indicates something
>> is wrong with write behind.
> 
> Yes, this is in some sense a main topic of my emails. I am just trying
> to get you more debugging data.
> 
>> I'm trying to review related code, however, this might be difficult,
>> can you discribe how do you reporduce this problem in detailed steps?
>> and I will try to reporduce this. If I still can't, can you apply a
>> debug patch and recompile the kernel to test?
> 
> I am trying to reproduce this using files and loops devices and I'll
> provide instructions.
> Regarding patches: yes, see my first email. I will be happy to test
> patches and collect more debug data.

Attached patch can provide debug info for each r10_bio that is
serialized or wait for serialization, to judge if the problem is
related to r1_bio dispatching or serialization algorithm.

After the problem is reporduced, just cat /sys/block/md77/md/debug

Thanks,
Kuai
> 
> Thanks,
> Alexey
> .
> 

--------------F0B8CD6D8E42720DACD5EE3B
Content-Type: text/plain; charset=UTF-8;
 name="0001-md-debug-r1_bio.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-md-debug-r1_bio.patch"

RnJvbSBlNmZhZmVhN2ZmNjJhODA5MmQ5MzdiNjNhZjRiOTg3MDZkMDZlNGYwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+CkRh
dGU6IFR1ZSwgMiBKYW4gMjAyNCAxMDowMjo0NiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIG1k
OiBkZWJ1ZyByMV9iaW8KClNpZ25lZC1vZmYtYnk6IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2Vp
LmNvbT4KLS0tCiBkcml2ZXJzL21kL21kLmMgICAgfCAxNSArKysrKysrKysrKysrCiBkcml2
ZXJzL21kL21kLmggICAgfCAgMSArCiBkcml2ZXJzL21kL3JhaWQxLmMgfCA1NCArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tCiBkcml2ZXJzL21kL3Jh
aWQxLmggfCAgNSArKysrKwogNCBmaWxlcyBjaGFuZ2VkLCA2NiBpbnNlcnRpb25zKCspLCA5
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbWQuYyBiL2RyaXZlcnMv
bWQvbWQuYwppbmRleCBjZTMyOTcwYWVjZGMuLjFkY2VlMTc3YWFhOCAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9tZC9tZC5jCisrKyBiL2RyaXZlcnMvbWQvbWQuYwpAQCAtNTU5OSw2ICs1NTk5
LDIwIEBAIHN0YXRpYyBzdHJ1Y3QgbWRfc3lzZnNfZW50cnkgbWRfc2VyaWFsaXplX3BvbGlj
eSA9CiBfX0FUVFIoc2VyaWFsaXplX3BvbGljeSwgU19JUlVHTyB8IFNfSVdVU1IsIHNlcmlh
bGl6ZV9wb2xpY3lfc2hvdywKICAgICAgICBzZXJpYWxpemVfcG9saWN5X3N0b3JlKTsKIAor
c3RhdGljIHNzaXplX3QKK2RlYnVnX3Nob3coc3RydWN0IG1kZGV2ICptZGRldiwgY2hhciAq
cGFnZSkKK3sKKwlzdHJ1Y3QgbWRfcGVyc29uYWxpdHkgKnBlcnMgPSBtZGRldi0+cGVyczsK
KworCWlmICghcGVycyB8fCAhcGVycy0+ZGVidWcpCisJCXJldHVybiBzcHJpbnRmKHBhZ2Us
ICJuL2FcbiIpOworCisJcGVycy0+ZGVidWcobWRkZXYpOworCXJldHVybiBzcHJpbnRmKHBh
Z2UsICJzZWUgZGVidWcgaW5mbyBpbiBrZXJuZWwgbG9nXG4iKTsKK30KKworc3RhdGljIHN0
cnVjdCBtZF9zeXNmc19lbnRyeSBtZF9kZWJ1ZyA9CitfX0FUVFIoZGVidWcsIDA0NDQsIGRl
YnVnX3Nob3csIE5VTEwpOwogCiBzdGF0aWMgc3RydWN0IGF0dHJpYnV0ZSAqbWRfZGVmYXVs
dF9hdHRyc1tdID0gewogCSZtZF9sZXZlbC5hdHRyLApAQCAtNTYxOSw2ICs1NjMzLDcgQEAg
c3RhdGljIHN0cnVjdCBhdHRyaWJ1dGUgKm1kX2RlZmF1bHRfYXR0cnNbXSA9IHsKIAkmbWRf
Y29uc2lzdGVuY3lfcG9saWN5LmF0dHIsCiAJJm1kX2ZhaWxfbGFzdF9kZXYuYXR0ciwKIAkm
bWRfc2VyaWFsaXplX3BvbGljeS5hdHRyLAorCSZtZF9kZWJ1Zy5hdHRyLAogCU5VTEwsCiB9
OwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmggYi9kcml2ZXJzL21kL21kLmgKaW5k
ZXggOGQ4ODFjYzU5Nzk5Li40MGZkNGUzMjRjZGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQv
bWQuaAorKysgYi9kcml2ZXJzL21kL21kLmgKQEAgLTYzMiw2ICs2MzIsNyBAQCBzdHJ1Y3Qg
bWRfcGVyc29uYWxpdHkKIAkgKiBhcnJheS4KIAkgKi8KIAl2b2lkICooKnRha2VvdmVyKSAo
c3RydWN0IG1kZGV2ICptZGRldik7CisJdm9pZCAoKmRlYnVnKSAoc3RydWN0IG1kZGV2ICpt
ZGRldik7CiAJLyogQ2hhbmdlcyB0aGUgY29uc2lzdGVuY3kgcG9saWN5IG9mIGFuIGFjdGl2
ZSBhcnJheS4gKi8KIAlpbnQgKCpjaGFuZ2VfY29uc2lzdGVuY3lfcG9saWN5KShzdHJ1Y3Qg
bWRkZXYgKm1kZGV2LCBjb25zdCBjaGFyICpidWYpOwogfTsKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbWQvcmFpZDEuYyBiL2RyaXZlcnMvbWQvcmFpZDEuYwppbmRleCBhYWE0MzRmMGMxNzUu
LmViNzYzZjQxZGNiYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9yYWlkMS5jCisrKyBiL2Ry
aXZlcnMvbWQvcmFpZDEuYwpAQCAtNjUsMTcgKzY1LDIzIEBAIHN0YXRpYyBpbnQgY2hlY2tf
YW5kX2FkZF9zZXJpYWwoc3RydWN0IG1kX3JkZXYgKnJkZXYsIHN0cnVjdCByMWJpbyAqcjFf
YmlvLAogCXNlY3Rvcl90IGxvID0gcjFfYmlvLT5zZWN0b3I7CiAJc2VjdG9yX3QgaGkgPSBs
byArIHIxX2Jpby0+c2VjdG9yczsKIAlzdHJ1Y3Qgc2VyaWFsX2luX3JkZXYgKnNlcmlhbCA9
ICZyZGV2LT5zZXJpYWxbaWR4XTsKKwlzdHJ1Y3QgcjFjb25mICpjb25mID0gcmRldi0+bWRk
ZXYtPnByaXZhdGU7CiAKLQlzcGluX2xvY2tfaXJxc2F2ZSgmc2VyaWFsLT5zZXJpYWxfbG9j
aywgZmxhZ3MpOworCXNwaW5fbG9ja19pcnFzYXZlKCZjb25mLT5kZWJ1Z19sb2NrLCBmbGFn
cyk7CisJc3Bpbl9sb2NrKCZzZXJpYWwtPnNlcmlhbF9sb2NrKTsKKwlsaXN0X2RlbF9pbml0
KCZyMV9iaW8tPmRlYnVnX2xpc3QpOwogCS8qIGNvbGxpc2lvbiBoYXBwZW5lZCAqLwotCWlm
IChyYWlkMV9yYl9pdGVyX2ZpcnN0KCZzZXJpYWwtPnNlcmlhbF9yYiwgbG8sIGhpKSkKKwlp
ZiAocmFpZDFfcmJfaXRlcl9maXJzdCgmc2VyaWFsLT5zZXJpYWxfcmIsIGxvLCBoaSkpIHsK
IAkJcmV0ID0gLUVCVVNZOwotCWVsc2UgeworCQlsaXN0X2FkZCgmcjFfYmlvLT5kZWJ1Z19s
aXN0LCAmY29uZi0+YnVzeV9saXN0KTsKKwl9IGVsc2UgewogCQlzaS0+c3RhcnQgPSBsbzsK
IAkJc2ktPmxhc3QgPSBoaTsKIAkJcmFpZDFfcmJfaW5zZXJ0KHNpLCAmc2VyaWFsLT5zZXJp
YWxfcmIpOworCQlsaXN0X2FkZCgmcjFfYmlvLT5kZWJ1Z19saXN0LCAmY29uZi0+d2FpdF9s
aXN0KTsKIAl9Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc2VyaWFsLT5zZXJpYWxfbG9j
aywgZmxhZ3MpOworCXNwaW5fdW5sb2NrKCZzZXJpYWwtPnNlcmlhbF9sb2NrKTsKKwlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZjb25mLT5kZWJ1Z19sb2NrLCBmbGFncyk7CiAKIAlyZXR1
cm4gcmV0OwogfQpAQCAtOTQsNyArMTAwLDggQEAgc3RhdGljIHZvaWQgd2FpdF9mb3Jfc2Vy
aWFsaXphdGlvbihzdHJ1Y3QgbWRfcmRldiAqcmRldiwgc3RydWN0IHIxYmlvICpyMV9iaW8p
CiAJCSAgIGNoZWNrX2FuZF9hZGRfc2VyaWFsKHJkZXYsIHIxX2Jpbywgc2ksIGlkeCkgPT0g
MCk7CiB9CiAKLXN0YXRpYyB2b2lkIHJlbW92ZV9zZXJpYWwoc3RydWN0IG1kX3JkZXYgKnJk
ZXYsIHNlY3Rvcl90IGxvLCBzZWN0b3JfdCBoaSkKK3N0YXRpYyB2b2lkIHJlbW92ZV9zZXJp
YWwoc3RydWN0IG1kX3JkZXYgKnJkZXYsIHNlY3Rvcl90IGxvLCBzZWN0b3JfdCBoaSwKKwkJ
CSAgc3RydWN0IHIxYmlvICpyMV9iaW8pCiB7CiAJc3RydWN0IHNlcmlhbF9pbmZvICpzaTsK
IAl1bnNpZ25lZCBsb25nIGZsYWdzOwpAQCAtMTAyLDEyICsxMDksMTUgQEAgc3RhdGljIHZv
aWQgcmVtb3ZlX3NlcmlhbChzdHJ1Y3QgbWRfcmRldiAqcmRldiwgc2VjdG9yX3QgbG8sIHNl
Y3Rvcl90IGhpKQogCXN0cnVjdCBtZGRldiAqbWRkZXYgPSByZGV2LT5tZGRldjsKIAlpbnQg
aWR4ID0gc2VjdG9yX3RvX2lkeChsbyk7CiAJc3RydWN0IHNlcmlhbF9pbl9yZGV2ICpzZXJp
YWwgPSAmcmRldi0+c2VyaWFsW2lkeF07CisJc3RydWN0IHIxY29uZiAqY29uZiA9IHJkZXYt
Pm1kZGV2LT5wcml2YXRlOwogCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJnNlcmlhbC0+c2VyaWFs
X2xvY2ssIGZsYWdzKTsKKwlzcGluX2xvY2tfaXJxc2F2ZSgmY29uZi0+ZGVidWdfbG9jaywg
ZmxhZ3MpOworCXNwaW5fbG9jaygmc2VyaWFsLT5zZXJpYWxfbG9jayk7CiAJZm9yIChzaSA9
IHJhaWQxX3JiX2l0ZXJfZmlyc3QoJnNlcmlhbC0+c2VyaWFsX3JiLCBsbywgaGkpOwogCSAg
ICAgc2k7IHNpID0gcmFpZDFfcmJfaXRlcl9uZXh0KHNpLCBsbywgaGkpKSB7CiAJCWlmIChz
aS0+c3RhcnQgPT0gbG8gJiYgc2ktPmxhc3QgPT0gaGkpIHsKIAkJCXJhaWQxX3JiX3JlbW92
ZShzaSwgJnNlcmlhbC0+c2VyaWFsX3JiKTsKKwkJCWxpc3RfZGVsX2luaXQoJnIxX2Jpby0+
ZGVidWdfbGlzdCk7CiAJCQltZW1wb29sX2ZyZWUoc2ksIG1kZGV2LT5zZXJpYWxfaW5mb19w
b29sKTsKIAkJCWZvdW5kID0gMTsKIAkJCWJyZWFrOwpAQCAtMTE1LDcgKzEyNSw4IEBAIHN0
YXRpYyB2b2lkIHJlbW92ZV9zZXJpYWwoc3RydWN0IG1kX3JkZXYgKnJkZXYsIHNlY3Rvcl90
IGxvLCBzZWN0b3JfdCBoaSkKIAl9CiAJaWYgKCFmb3VuZCkKIAkJV0FSTigxLCAiVGhlIHdy
aXRlIElPIGlzIG5vdCByZWNvcmRlZCBmb3Igc2VyaWFsaXphdGlvblxuIik7Ci0Jc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmc2VyaWFsLT5zZXJpYWxfbG9jaywgZmxhZ3MpOworCXNwaW5f
dW5sb2NrKCZzZXJpYWwtPnNlcmlhbF9sb2NrKTsKKwlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZjb25mLT5kZWJ1Z19sb2NrLCBmbGFncyk7CiAJd2FrZV91cCgmc2VyaWFsLT5zZXJpYWxf
aW9fd2FpdCk7CiB9CiAKQEAgLTMxNCw2ICszMjUsNyBAQCBzdGF0aWMgdm9pZCByYWlkX2Vu
ZF9iaW9faW8oc3RydWN0IHIxYmlvICpyMV9iaW8pCiAJc3RydWN0IHIxY29uZiAqY29uZiA9
IHIxX2Jpby0+bWRkZXYtPnByaXZhdGU7CiAJc2VjdG9yX3Qgc2VjdG9yID0gcjFfYmlvLT5z
ZWN0b3I7CiAKKwlCVUdfT04oIWxpc3RfZW1wdHkoJnIxX2Jpby0+ZGVidWdfbGlzdCkpOwog
CS8qIGlmIG5vYm9keSBoYXMgZG9uZSB0aGUgZmluYWwgZW5kaW8geWV0LCBkbyBpdCBub3cg
Ki8KIAlpZiAoIXRlc3RfYW5kX3NldF9iaXQoUjFCSU9fUmV0dXJuZWQsICZyMV9iaW8tPnN0
YXRlKSkgewogCQlwcl9kZWJ1ZygicmFpZDE6IHN5bmMgZW5kICVzIG9uIHNlY3RvcnMgJWxs
dS0lbGx1XG4iLApAQCAtNTI1LDcgKzUzNyw3IEBAIHN0YXRpYyB2b2lkIHJhaWQxX2VuZF93
cml0ZV9yZXF1ZXN0KHN0cnVjdCBiaW8gKmJpbykKIAogCWlmIChiZWhpbmQpIHsKIAkJaWYg
KHRlc3RfYml0KENvbGxpc2lvbkNoZWNrLCAmcmRldi0+ZmxhZ3MpKQotCQkJcmVtb3ZlX3Nl
cmlhbChyZGV2LCBsbywgaGkpOworCQkJcmVtb3ZlX3NlcmlhbChyZGV2LCBsbywgaGksIHIx
X2Jpbyk7CiAJCWlmICh0ZXN0X2JpdChXcml0ZU1vc3RseSwgJnJkZXYtPmZsYWdzKSkKIAkJ
CWF0b21pY19kZWMoJnIxX2Jpby0+YmVoaW5kX3JlbWFpbmluZyk7CiAKQEAgLTU0OSw3ICs1
NjEsNyBAQCBzdGF0aWMgdm9pZCByYWlkMV9lbmRfd3JpdGVfcmVxdWVzdChzdHJ1Y3QgYmlv
ICpiaW8pCiAJCQl9CiAJCX0KIAl9IGVsc2UgaWYgKHJkZXYtPm1kZGV2LT5zZXJpYWxpemVf
cG9saWN5KQotCQlyZW1vdmVfc2VyaWFsKHJkZXYsIGxvLCBoaSk7CisJCXJlbW92ZV9zZXJp
YWwocmRldiwgbG8sIGhpLCByMV9iaW8pOwogCWlmIChyMV9iaW8tPmJpb3NbbWlycm9yXSA9
PSBOVUxMKQogCQlyZGV2X2RlY19wZW5kaW5nKHJkZXYsIGNvbmYtPm1kZGV2KTsKIApAQCAt
MTIwNiw2ICsxMjE4LDcgQEAgYWxsb2NfcjFiaW8oc3RydWN0IG1kZGV2ICptZGRldiwgc3Ry
dWN0IGJpbyAqYmlvKQogCS8qIEVuc3VyZSBubyBiaW8gcmVjb3JkcyBJT19CTE9DS0VEICov
CiAJbWVtc2V0KHIxX2Jpby0+YmlvcywgMCwgY29uZi0+cmFpZF9kaXNrcyAqIHNpemVvZihy
MV9iaW8tPmJpb3NbMF0pKTsKIAlpbml0X3IxYmlvKHIxX2JpbywgbWRkZXYsIGJpbyk7CisJ
SU5JVF9MSVNUX0hFQUQoJnIxX2Jpby0+ZGVidWdfbGlzdCk7CiAJcmV0dXJuIHIxX2JpbzsK
IH0KIApAQCAtMzAwNiw2ICszMDE5LDcgQEAgc3RhdGljIHN0cnVjdCByMWNvbmYgKnNldHVw
X2NvbmYoc3RydWN0IG1kZGV2ICptZGRldikKIAogCWVyciA9IC1FSU5WQUw7CiAJc3Bpbl9s
b2NrX2luaXQoJmNvbmYtPmRldmljZV9sb2NrKTsKKwlzcGluX2xvY2tfaW5pdCgmY29uZi0+
ZGVidWdfbG9jayk7CiAJcmRldl9mb3JfZWFjaChyZGV2LCBtZGRldikgewogCQlpbnQgZGlz
a19pZHggPSByZGV2LT5yYWlkX2Rpc2s7CiAJCWlmIChkaXNrX2lkeCA+PSBtZGRldi0+cmFp
ZF9kaXNrcwpAQCAtMzAyNSw2ICszMDM5LDggQEAgc3RhdGljIHN0cnVjdCByMWNvbmYgKnNl
dHVwX2NvbmYoc3RydWN0IG1kZGV2ICptZGRldikKIAljb25mLT5yYWlkX2Rpc2tzID0gbWRk
ZXYtPnJhaWRfZGlza3M7CiAJY29uZi0+bWRkZXYgPSBtZGRldjsKIAlJTklUX0xJU1RfSEVB
RCgmY29uZi0+cmV0cnlfbGlzdCk7CisJSU5JVF9MSVNUX0hFQUQoJmNvbmYtPmJ1c3lfbGlz
dCk7CisJSU5JVF9MSVNUX0hFQUQoJmNvbmYtPndhaXRfbGlzdCk7CiAJSU5JVF9MSVNUX0hF
QUQoJmNvbmYtPmJpb19lbmRfaW9fbGlzdCk7CiAKIAlzcGluX2xvY2tfaW5pdCgmY29uZi0+
cmVzeW5jX2xvY2spOwpAQCAtMzM1Miw2ICszMzY4LDcgQEAgc3RhdGljIHZvaWQgKnJhaWQx
X3Rha2VvdmVyKHN0cnVjdCBtZGRldiAqbWRkZXYpCiAJCW1kZGV2LT5uZXdfY2h1bmtfc2Vj
dG9ycyA9IDA7CiAJCWNvbmYgPSBzZXR1cF9jb25mKG1kZGV2KTsKIAkJaWYgKCFJU19FUlIo
Y29uZikpIHsKKwogCQkJLyogQXJyYXkgbXVzdCBhcHBlYXIgdG8gYmUgcXVpZXNjZWQgKi8K
IAkJCWNvbmYtPmFycmF5X2Zyb3plbiA9IDE7CiAJCQltZGRldl9jbGVhcl91bnN1cHBvcnRl
ZF9mbGFncyhtZGRldiwKQEAgLTMzNjIsNiArMzM3OSwyNCBAQCBzdGF0aWMgdm9pZCAqcmFp
ZDFfdGFrZW92ZXIoc3RydWN0IG1kZGV2ICptZGRldikKIAlyZXR1cm4gRVJSX1BUUigtRUlO
VkFMKTsKIH0KIAorc3RhdGljIHZvaWQgcmFpZDFfZGVidWcoc3RydWN0IG1kZGV2ICptZGRl
dikKK3sKKwlzdHJ1Y3QgcjFjb25mICpjb25mID0gbWRkZXYtPnByaXZhdGU7CisJdW5zaWdu
ZWQgbG9uZyBmbGFnczsKKwlzdHJ1Y3QgcjFiaW8gKnIxX2JpbzsKKworCXNwaW5fbG9ja19p
cnFzYXZlKCZjb25mLT5kZWJ1Z19sb2NrLCBmbGFncyk7CisJbGlzdF9mb3JfZWFjaF9lbnRy
eShyMV9iaW8sICZjb25mLT5idXN5X2xpc3QsIGRlYnVnX2xpc3QpIHsKKwkJcHJpbnRrKCIl
czogcjFfYmlvICVweCBidXN5ICglbGx1ICsgJXUpXG4iLCBfX2Z1bmNfXywgcjFfYmlvLAor
CQkgICAgICAgcjFfYmlvLT5zZWN0b3IsIHIxX2Jpby0+c2VjdG9ycyk7CisJfQorCWxpc3Rf
Zm9yX2VhY2hfZW50cnkocjFfYmlvLCAmY29uZi0+d2FpdF9saXN0LCBkZWJ1Z19saXN0KSB7
CisJCXByaW50aygiJXM6IHIxX2JpbyAlcHggd2FpdCAoJWxsdSArICV1KVxuIiwgX19mdW5j
X18sIHIxX2JpbywKKwkJICAgICAgIHIxX2Jpby0+c2VjdG9yLCByMV9iaW8tPnNlY3RvcnMp
OworCX0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZjb25mLT5kZWJ1Z19sb2NrLCBmbGFn
cyk7Cit9CisKIHN0YXRpYyBzdHJ1Y3QgbWRfcGVyc29uYWxpdHkgcmFpZDFfcGVyc29uYWxp
dHkgPQogewogCS5uYW1lCQk9ICJyYWlkMSIsCkBAIC0zMzgxLDYgKzM0MTYsNyBAQCBzdGF0
aWMgc3RydWN0IG1kX3BlcnNvbmFsaXR5IHJhaWQxX3BlcnNvbmFsaXR5ID0KIAkuY2hlY2tf
cmVzaGFwZQk9IHJhaWQxX3Jlc2hhcGUsCiAJLnF1aWVzY2UJPSByYWlkMV9xdWllc2NlLAog
CS50YWtlb3Zlcgk9IHJhaWQxX3Rha2VvdmVyLAorCS5kZWJ1ZwkJPSByYWlkMV9kZWJ1ZywK
IH07CiAKIHN0YXRpYyBpbnQgX19pbml0IHJhaWRfaW5pdCh2b2lkKQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tZC9yYWlkMS5oIGIvZHJpdmVycy9tZC9yYWlkMS5oCmluZGV4IDE0ZDQyMTFh
MTIzYS4uODE2M2EzZmI2ZTQ4IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL3JhaWQxLmgKKysr
IGIvZHJpdmVycy9tZC9yYWlkMS5oCkBAIC03OSw2ICs3OSwxMCBAQCBzdHJ1Y3QgcjFjb25m
IHsKIAkgKiBibG9jaywgb3IgYW55dGhpbmcgZWxzZS4KIAkgKi8KIAlzdHJ1Y3QgbGlzdF9o
ZWFkCXJldHJ5X2xpc3Q7CisKKwlzcGlubG9ja190CQlkZWJ1Z19sb2NrOworCXN0cnVjdCBs
aXN0X2hlYWQJYnVzeV9saXN0OworCXN0cnVjdCBsaXN0X2hlYWQJd2FpdF9saXN0OwogCS8q
IEEgc2VwYXJhdGUgbGlzdCBvZiByMWJpbyB3aGljaCBqdXN0IG5lZWQgcmFpZF9lbmRfYmlv
X2lvIGNhbGxlZC4KIAkgKiBUaGlzIG11c3RuJ3QgaGFwcGVuIGZvciB3cml0ZXMgd2hpY2gg
aGFkIGFueSBlcnJvcnMgaWYgdGhlIHN1cGVyYmxvY2sKIAkgKiBuZWVkcyB0byBiZSB3cml0
dGVuLgpAQCAtMTY4LDYgKzE3Miw3IEBAIHN0cnVjdCByMWJpbyB7CiAJaW50CQkJcmVhZF9k
aXNrOwogCiAJc3RydWN0IGxpc3RfaGVhZAlyZXRyeV9saXN0OworCXN0cnVjdCBsaXN0X2hl
YWQJZGVidWdfbGlzdDsKIAogCS8qCiAJICogV2hlbiBSMUJJT19CZWhpbmRJTyBpcyBzZXQs
IHdlIHN0b3JlIHBhZ2VzIGZvciB3cml0ZSBiZWhpbmQKLS0gCjIuMzkuMgoK
--------------F0B8CD6D8E42720DACD5EE3B--

