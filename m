From: "NeilBrown" <neilb@suse.de>
Subject: Re: Software, Raid 5, Different Size Drives.
Date: Mon, 7 Sep 2009 20:52:53 +1000 (EST)
Message-ID: <df369067b4edb525a93983efaedd959f.squirrel@neil.brown.name>
References: <851324.19026.qm@web51304.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <851324.19026.qm@web51304.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, September 7, 2009 8:35 pm, Jon Hardcastle wrote:
> --- On Sun, 16/8/09, NeilBrown <neilb@suse.de> wrote:
>
> ...
>
>> >
>> > (also anyone know if raid5 to raid 6 native support is
>> anywhere near?)
>>
>> Yes. It works with 2.6.30 (or preferrable 2.6.31) and the
>> devel-3.1 branch
>> from my git tree git://neil.brown.name/mdadm
>>
>> NeilBrown
>>
>
> I am probably being a bit thick here, but I am running 2.6.8 as per
>
> http://packages.gentoo.org/package/sys-fs/mdadm
>
> Does this imply that I already have these features.. as i am pretty sure i
> don't (unless it is undocumented)

No you don't.
2.6.8 is < 3.1, so your mdadm doesn't have the required support
And you need a kernel which is at least 2.6.30.

>
> I want to add 2 more drives to my array and grow it/reshape from raid 5 to
> 6...

You'll need to be a bit more patient.

NeilBrown

