From: hansbkk@gmail.com
Subject: Re: Software RAID and Fakeraid
Date: Wed, 2 Feb 2011 23:09:13 +0700
Message-ID: <AANLkTinDrmxhSFbj5assuCPEPY-eAxeuVs-4D4xqhKi=@mail.gmail.com>
References: <4CF81A16.2010606@cfl.rr.com>
	<20101203123615.6edce071@notabene.brown>
	<4CF860EB.7010005@cfl.rr.com>
	<20101209094354.4c6aaa93@notabene.brown>
	<4D01328D.9050503@cfl.rr.com>
	<4D46E6D7.2000205@cfl.rr.com>
	<20110131170349.GR343@caffeine.csclub.uwaterloo.ca>
	<4D470BCF.20508@cfl.rr.com>
	<20110131221252.GT343@caffeine.csclub.uwaterloo.ca>
	<4D47627A.1080509@cfl.rr.com>
	<20110201162642.GU343@caffeine.csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201162642.GU343@caffeine.csclub.uwaterloo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: grub-devel@gnu.org
List-Id: linux-raid.ids

On Tue, Feb 1, 2011 at 11:26 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
> I personally consider soft raid on raw devices so convluted that I
> have never done it. =A0I would rather have something I know works wit=
h my
> bootloader and other tools, than gain that extra 1MB (at most) that n=
ot
> having partitions gives. =A0Also given many PCs won't boot from a dri=
ve
> without a partition table, it isn't even an option then.

=46or others googling this later, another very good reason for *never*
RAID'ing raw block devices (ie always creating at least one partition
first) is that if you ever mistakenly boot into some flavors of
Windows (even from some optical discs, perhaps unknowingly left ina
drive), your disks will automatically get "helpfully" initialized, as
windoze thinks it's a brand new empty drive being offered up like a
virgin for sacrifice - **poof** there goes all your data.

Speaking from experience 8-(
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
