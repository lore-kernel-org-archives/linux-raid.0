From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Subject: Re: BUG drivers/md/md.c: data-offset reshape renders array unloadable
Date: Sun, 25 Jan 2015 17:46:20 +0100
Message-ID: <CAA-O0Xjw8H1nPsi+MsQnrLxv=gC2tj3=W=t3aMnCE6ESUHMF8w@mail.gmail.com>
References: <CAA-O0Xjustt5=nNoDzXukY=f-7OwRk=yqug8MCpxcXCt4MdiTw@mail.gmail.com>
	<CAA-O0XgXc0H4H__8ygLzt_BBW3NpEseG9NZBTZ_syMdir8D=mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c1ed7ee5d7ac050d7cc27c
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA-O0XgXc0H4H__8ygLzt_BBW3NpEseG9NZBTZ_syMdir8D=mA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--001a11c1ed7ee5d7ac050d7cc27c
Content-Type: text/plain; charset=UTF-8

On Sat, Jan 24, 2015 at 11:23 PM, Wesley W. Terpstra <wesley@terpstra.ca> wrote:
>> First, it is obviously the last test in super_1_load that is rejecting
>> the array. The superblock reports more sectors than are calculated, so
>> the check
>>         if (sectors < le64_to_cpu(sb->data_size)) {
>> fails.
>
> Thus, an alternative explanation could be that the the sb->data_size
> was not updated after the reshape completed.

I can confirm that this was the problem.

I manually modified my super block using the attached quick hack.
Thereafter I was able to reassemble the array and fsck everything
successfully.

I will try and see if I can reproduce the problem tomorrow. It's a
pretty nasty bug to have a reshape complete and render your array
unassemblable.

--001a11c1ed7ee5d7ac050d7cc27c
Content-Type: text/x-csrc; charset=US-ASCII; name="fix-size.c"
Content-Disposition: attachment; filename="fix-size.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i5cnrbm80

I2luY2x1ZGUgPHN0cmluZy5oPgojaW5jbHVkZSA8c3RkaW50Lmg+CiNpbmNsdWRlIDxpbnR0eXBl
cy5oPgojaW5jbHVkZSA8c3RkaW8uaD4KCmludCBtYWluKCkgewogIGNoYXIgYnVmWzUxMl07CiAg
dWludDY0X3QgZGF0YV9vZmZzZXQsIGRhdGFfc2l6ZSwgcmVzaGFwZV9wb3NpdGlvbjsKICB1aW50
MzJfdCBjaGVja3N1bTsKICAKICBmcmVhZChidWYsIHNpemVvZihidWYpLCAxLCBzdGRpbik7CiAg
CiAgLyogQXNzdW1lcyBsaXR0bGUtZW5kaWFuICovCiAgbWVtY3B5KCZyZXNoYXBlX3Bvc2l0aW9u
LCBidWYrMHg2OCwgOCk7CiAgbWVtY3B5KCZkYXRhX29mZnNldCwgYnVmKzB4ODAsIDgpOwogIG1l
bWNweSgmZGF0YV9zaXplLCAgIGJ1ZisweDg4LCA4KTsKICBtZW1jcHkoJmNoZWNrc3VtLCAgICBi
dWYrMHhEOCwgNCk7CiAgCiAgZnByaW50ZihzdGRlcnIsICJkYXRhX29mZnNldDogJSJQUkl1NjQi
XG4iLCBkYXRhX29mZnNldCk7CiAgZnByaW50ZihzdGRlcnIsICJkYXRhX3NpemU6ICAgJSJQUkl1
NjQiXG4iLCBkYXRhX3NpemUpOwogIGZwcmludGYoc3RkZXJyLCAicmVzaGFwZTogICAgICUiUFJJ
dTY0IlxuIiwgcmVzaGFwZV9wb3NpdGlvbik7CiAgZnByaW50ZihzdGRlcnIsICJjaGVja3N1bTog
ICAgJXhcbiIsIGNoZWNrc3VtKTsKICAKICAvKiBBc3N1bWVzIG5vIG92ZXJmbG93ICovCiAgY2hl
Y2tzdW0gKz0gKDU4NDI4OTQ4NDggLSBkYXRhX3NpemUpOwogIGRhdGFfc2l6ZSA9IDU4NDI4OTQ4
NDg7CiAgCiAgbWVtY3B5KGJ1ZisweDg4LCAmZGF0YV9zaXplLCA4KTsKICBtZW1jcHkoYnVmKzB4
RDgsICZjaGVja3N1bSwgIDQpOwogICAKICBmd3JpdGUoYnVmLCBzaXplb2YoYnVmKSwgMSwgc3Rk
b3V0KTsKICAKICByZXR1cm4gMDsKfQo=
--001a11c1ed7ee5d7ac050d7cc27c--
