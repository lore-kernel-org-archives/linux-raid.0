From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Wed, 14 Mar 2012 09:30:19 +0800
Message-ID: <CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com>
References: <20120312030412.375458948@fusionio.com>
	<alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
	<4F5EFEB6.4060402@kernel.org>
	<alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
	<CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
	<alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3005ddca1e1b8404bb29eb95
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-raid.ids

--20cf3005ddca1e1b8404bb29eb95
Content-Type: text/plain; charset=ISO-8859-1

2012/3/13 Holger Kiehl <Holger.Kiehl@dwd.de>:
> On Tue, 13 Mar 2012, Shaohua Li wrote:
>
>> Thanks for testing. This is very wield, the req->__data_len is wrong.
>> Is this a clean build?
>>
> I just downloaded linux-3.3-rc7.tar.bz2 from kernel.org and applied
> your patches again. The result is the same.
>
> Am I the only one experiencing these problems?
Martin Petersen pointed out scsi layer doesn't support discard merge, which
might be the reason you see the error message (my drive isn't a scsi device).
can you please try attached patch?

Thanks,
Shaohua

--20cf3005ddca1e1b8404bb29eb95
Content-Type: application/octet-stream; name="blk-discard-nomerge.patch"
Content-Disposition: attachment; filename="blk-discard-nomerge.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gzroxhje0

RGlkbid0IGFsbG93IGRpc2NhcmQgcmVxdWVzdCBtZXJnZSB0ZW1wb3JhcmlseSwgYXMgU0NTSSBs
YXllciBpc24ndCByZWFkeQpmb3IgZGlzY2FyZCBtZXJnZSBhcyBNYXJ0aW4gUGV0ZXJzZW4gcG9p
bnRlZCBvdXQuCgpTaWduZWQtb2ZmLWJ5OiBTaGFvaHVhIExpIDxzaGxpQGZ1c2lvbmlvLmNvbT4K
LS0tCiBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oIHwgICAgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpJbmRleDogbGludXgvaW5jbHVkZS9saW51eC9i
bGtkZXYuaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC5vcmlnL2luY2x1ZGUvbGludXgvYmxrZGV2LmgJ
MjAxMi0wMy0xNCAwOToyMDowNi43ODcyNjExODggKzA4MDAKKysrIGxpbnV4L2luY2x1ZGUvbGlu
dXgvYmxrZGV2LmgJMjAxMi0wMy0xNCAwOToyMDo0Ny43OTcyNjEyNDggKzA4MDAKQEAgLTU3NSw3
ICs1NzUsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgYmxrX2NsZWFyX3F1ZXVlX2Z1bGwoCiAgKiBp
dCBhbHJlYWR5IGJlIHN0YXJ0ZWQgYnkgZHJpdmVyLgogICovCiAjZGVmaW5lIFJRX05PTUVSR0Vf
RkxBR1MJXAotCShSRVFfTk9NRVJHRSB8IFJFUV9TVEFSVEVEIHwgUkVRX1NPRlRCQVJSSUVSIHwg
UkVRX0ZMVVNIIHwgUkVRX0ZVQSkKKwkoUkVRX05PTUVSR0UgfCBSRVFfU1RBUlRFRCB8IFJFUV9T
T0ZUQkFSUklFUiB8IFJFUV9GTFVTSCB8IFJFUV9GVUEgfCBSRVFfRElTQ0FSRCkKICNkZWZpbmUg
cnFfbWVyZ2VhYmxlKHJxKQlcCiAJKCEoKHJxKS0+Y21kX2ZsYWdzICYgUlFfTk9NRVJHRV9GTEFH
UykgJiYgXAogCSAoKChycSktPmNtZF9mbGFncyAmIFJFUV9ESVNDQVJEKSB8fCBcCg==
--20cf3005ddca1e1b8404bb29eb95--
