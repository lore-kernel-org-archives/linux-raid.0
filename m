From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [BUG] NULL pointer in raid1_make_request passed to bio_trim when
 adding md as bcache caching dev
Date: Sat, 26 Mar 2016 23:40:38 +0800
Message-ID: <CACVXFVO7ARehcQHvBuRoVHZhc0BgA5kKxaPQTqMT7Y=4Ca6urw@mail.gmail.com>
References: <56F4058B.1030309@roesner-online.de>
	<alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
	<alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net>
	<56F54712.6090202@roesner-online.de>
	<alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c0afb145215f4052ef580e1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, Ming Lin <mlin@kernel.org>, Vlad-Cosmin Miu <miuvlad@gmail.com>, rjones@redhat.com, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-raid.ids

--94eb2c0afb145215f4052ef580e1
Content-Type: text/plain; charset=UTF-8

On Sat, Mar 26, 2016 at 4:44 AM, Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> [ +cc's, intentional top post ]
>
> Hello linux-raid list, please see below:
>
> A problem where bio_trim() dereferences a NULL pointer via
> bio->bi_iter.bi_size (0+0x28) has been reported at least three times when
> passing DISCARDs into raid1's.  I could be wrong here, but I'm guessing
> the cause of these three reports are the same:
>
> [2014-02-04] https://bugzilla.redhat.com/show_bug.cgi?id=1061339
> [2016-01-13] http://www.spinics.net/lists/linux-bcache/msg03335.html
>              https://bugzilla.kernel.org/show_bug.cgi?id=110771
> [2016-03-25] http://thread.gmane.org/gmane.linux.kernel.bcache.devel/3607 [this thread]
>              https://bugzilla.kernel.org/show_bug.cgi?id=114871
>
> Is there something that needs to be done differently with DISCARD bio's,
> perhaps related to splitting?  We added BUG_ON(!bio) in bcache's
> prio_io() function (see backtrace below) and didn't trip, so we know that
> bcache isn't passing null bio pointers.
>
> Perhaps there is an issue in either of blk_queue_split() or
> md_make_request() even before it gets to raid1_make_request()?

From the trace, looks the bio returned from bio_clone_mddev() is NULL,
and maybe the source bio is buggy, something like the attached patch
might be helpful, could you apply the attached debug patch, reproduce
and post the log?

thanks,

>
> Please add Cc's for anyone who might be able to help solve this problem.
>
> Thanks you for your help!
>
> --
> Eric Wheeler
>
> On Fri, 25 Mar 2016, Sebastian Roesner wrote:
>
>> Hi Eric,
>>
>> Am 25.03.2016 um 05:18 schrieb Eric Wheeler:
>> > Please send this output:
>> >
>> > tail /sys/block/md2/queue/discard_*
>>
>> # tail /sys/block/md2/queue/discard_*
>> ==> /sys/block/md2/queue/discard_granularity <==
>> 4096
>>
>> ==> /sys/block/md2/queue/discard_max_bytes <==
>> 2147450880
>>
>> ==> /sys/block/md2/queue/discard_max_hw_bytes <==
>> 2147450880
>>
>> ==> /sys/block/md2/queue/discard_zeroes_data <==
>> 0
>>
>> root@gropius:/home/sroesner# echo /dev/md2 > /sys/fs/bcache/register
>> sroesner@gropius:~$
>>
>> -> it killed my bash.
>>
>> Trace with patches and BUG_ON patch:
>>
>> [  172.660142] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000028
>> [  172.660229] IP: [<ffffffff811e53b4>] bio_trim+0xf/0x2a
>> [  172.660289] PGD 7faf3e067 PUD 7f9279067 PMD 0
>> [  172.660399] Oops: 0000 [#1] SMP
>> [...]
>> [  172.664780] Call Trace:
>> [  172.664813]  [<ffffffffa007f3be>] ? raid1_make_request+0x2e8/0xad7 [raid1]
>> [  172.664846]  [<ffffffff811f07da>] ? blk_queue_split+0x377/0x3d4
>> [  172.664880]  [<ffffffffa005fb5f>] ? md_make_request+0xf6/0x1e9 [md_mod]
>> [  172.664912]  [<ffffffff811eb860>] ? generic_make_request+0xb5/0x155
>> [  172.664947]  [<ffffffffa0445c89>] ? prio_io+0x85/0x95 [bcache]
>> [  172.664981]  [<ffffffffa0448252>] ? register_cache_set+0x355/0x8d0 [bcache]
>> [  172.665016]  [<ffffffffa04497d3>] ? register_bcache+0x1006/0x1174 [bcache]
>>
>> See http://pastebin.com/6CHtky2x for complete traces.
>>
>> Sebastian
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>

--94eb2c0afb145215f4052ef580e1
Content-Type: text/x-patch; charset=US-ASCII; name="raid1-check-bio.patch"
Content-Disposition: attachment; filename="raid1-check-bio.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_im9az2ps0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDEuYyBiL2RyaXZlcnMvbWQvcmFpZDEuYwppbmRl
eCAzOWZiMjFlLi45NTYyMDVkIDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL3JhaWQxLmMKKysrIGIv
ZHJpdmVycy9tZC9yYWlkMS5jCkBAIC0xMDQ0LDYgKzEwNDQsMjcgQEAgc3RhdGljIHZvaWQgcmFp
ZDFfdW5wbHVnKHN0cnVjdCBibGtfcGx1Z19jYiAqY2IsIGJvb2wgZnJvbV9zY2hlZHVsZSkKIAlr
ZnJlZShwbHVnKTsKIH0KIAorc3RhdGljIHZvaWQgY2hlY2tfYmlvKHN0cnVjdCBiaW8gKmJpbywg
Ym9vbCBjaGVjaykKK3sKKwlzdHJ1Y3QgYmlvX3ZlYyBidmVjOworCXN0cnVjdCBidmVjX2l0ZXIg
aXRlciA9IGJpby0+YmlfaXRlcjsKKwlpbnQgaSA9IDA7CisKKwlpZiAoIWNoZWNrKQorCQlyZXR1
cm47CisKKwlwcmludGsoIiVzOiBkdW1wIGJpbyAlcCBzZWdzOiVkIGY6JXggbWF4X2J2ZWNzOiVk
IGlvdjolcFxuIiwKKwkJCV9fZnVuY19fLCBiaW8sIGJpb19zZWdtZW50cyhiaW8pLCBiaW8tPmJp
X2ZsYWdzLAorCQkJYmlvLT5iaV9tYXhfdmVjcywgYmlvLT5iaV9pb192ZWMpOworCXByaW50aygi
XHQgaXRlcjogJXUgJXUgJXVcbiIsIGl0ZXIuYmlfc2l6ZSwgaXRlci5iaV9pZHgsCisJICAgICAg
IGl0ZXIuYmlfYnZlY19kb25lKTsKKwliaW9fZm9yX2VhY2hfc2VnbWVudChidmVjLCBiaW8sIGl0
ZXIpIHsKKwkJcHJpbnRrKCJcdCAlNGQ6ICV1ICV1ICVsdVxuIiwKKwkJICAgICAgIGksIGJ2ZWMu
YnZfb2Zmc2V0LCBidmVjLmJ2X2xlbiwKKwkJICAgICAgICh1bnNpZ25lZCBsb25nKXBhZ2VfdG9f
cGZuKGJ2ZWMuYnZfcGFnZSkpOworCX0KK30KKwogc3RhdGljIHZvaWQgcmFpZDFfbWFrZV9yZXF1
ZXN0KHN0cnVjdCBtZGRldiAqbWRkZXYsIHN0cnVjdCBiaW8gKiBiaW8pCiB7CiAJc3RydWN0IHIx
Y29uZiAqY29uZiA9IG1kZGV2LT5wcml2YXRlOwpAQCAtMTE1Nyw2ICsxMTc4LDcgQEAgcmVhZF9h
Z2FpbjoKIAkJcjFfYmlvLT5zdGFydF9uZXh0X3dpbmRvdyA9IDA7CiAKIAkJcmVhZF9iaW8gPSBi
aW9fY2xvbmVfbWRkZXYoYmlvLCBHRlBfTk9JTywgbWRkZXYpOworCQljaGVja19iaW8oYmlvLCAh
cmVhZF9iaW8pOwogCQliaW9fdHJpbShyZWFkX2JpbywgcjFfYmlvLT5zZWN0b3IgLSBiaW8tPmJp
X2l0ZXIuYmlfc2VjdG9yLAogCQkJIG1heF9zZWN0b3JzKTsKIApAQCAtMTMzOCw2ICsxMzYwLDcg
QEAgcmVhZF9hZ2FpbjoKIAkJCWNvbnRpbnVlOwogCiAJCW1iaW8gPSBiaW9fY2xvbmVfbWRkZXYo
YmlvLCBHRlBfTk9JTywgbWRkZXYpOworCQljaGVja19iaW8oYmlvLCAhbWJpbyk7CiAJCWJpb190
cmltKG1iaW8sIHIxX2Jpby0+c2VjdG9yIC0gYmlvLT5iaV9pdGVyLmJpX3NlY3RvciwgbWF4X3Nl
Y3RvcnMpOwogCiAJCWlmIChmaXJzdF9jbG9uZSkgewo=
--94eb2c0afb145215f4052ef580e1--
