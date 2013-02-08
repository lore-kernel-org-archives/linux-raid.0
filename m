From: John Gehring <john.gehring@gmail.com>
Subject: Re: mdadm: hot remove failed for /dev/sdg: Device or resource busy
Date: Fri, 8 Feb 2013 13:55:49 -0700
Message-ID: <CALwOXvKmgnf8ebHhhyq08M7be_QeAjONzrqB_03UvKXfgafYGQ@mail.gmail.com>
References: <eqndu9x4h8.ln2@goaway.wombat.san-francisco.ca.us>
	<csvfu9xsdm.ln2@goaway.wombat.san-francisco.ca.us>
	<20130208195935.GA1575@cthulhu.home.robinhill.me.uk>
	<am2gu9xjvm.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <am2gu9xjvm.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Not sure, but you may want to read the thread:

6. 2012-01-03  Re: [PATCH] FIX: Cannot remove failed disk from conta
linux-rai NeilBrown


http://marc.info/?l=linux-raid&m=132555140730996&w=2

On Fri, Feb 8, 2013 at 1:10 PM, Keith Keller
<kkeller@wombat.san-francisco.ca.us> wrote:
> Hi Robin,
>
> On 2013-02-08, Robin Hill <robin@robinhill.me.uk> wrote:
>> "mdadm --remove failed" would probably be best. There's also
>> "mdadm --remove missing" which is the other option in these
>> circumstances.
>
> I apologize: I should have mentioned that I had already tried --remove
> failed.  I tried --remove missing, but that didn't help either:
>
> # mdadm /dev/md127 --remove failed
> mdadm: hot remove failed for 8:96: Device or resource busy
> # mdadm /dev/md127 --remove missing
> mdadm: 'missing' only meaningful with --re-add
>
> I know the disk is dead, so I don't want to re-add it.  The error from
> --remove failed is basically the same as --remove /dev/sdg except with
> the major:minor numbers instead of the device file name.
>
> When I do a --remove failed (or --remove /dev/sdg), I also get this
> error in dmesg:
>
> md: cannot remove active disk sdg from md127 ...
>
> That seems to imply that, while the disk is marked "faulty spare
> rebuilding" in the array, the array is not totally willing to give it
> up.
>
> --keith
>
> --
> kkeller@wombat.san-francisco.ca.us
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
