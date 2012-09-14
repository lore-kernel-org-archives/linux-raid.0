From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Small short question Was: Re: Recovering from the kernel bug, Neil?
Date: Fri, 14 Sep 2012 13:51:46 +0200
Message-ID: <50531A52.7060205@schinagl.nl>
References: <5030F07F.7000303@schinagl.nl> <504CFA7B.7090606@schinagl.nl> <20120910090829.19100cdf@notabene.brown> <504DA85C.6080000@schinagl.nl> <20120911161622.0b0fcf8c@notabene.brown> <505301E1.10707@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505301E1.10707@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Since I had only one valid device to check with etc, I assume that if 
fsck -n -f /dev/md2 runs sucessfully, it is 100% safe to assume the 
array is perfectly healthy?

E.g. it should be perfectly safe to mdadm --zero-superblock on /dev/sda6 
and add it to /dev/md2 (missing /dev/sdb6)?

I know technically this all works out fine, and the bug shouldn't have 
broken anything in that regard. Or is it absolutly recommended to simply 
create a new array, with a new FS on it, and copy all data over 
(Logically also with /dev/md2, /dev/sda6 missing and later adding sdb6)?

Oliver

On 09/14/12 12:07, Oliver Schinagl wrote:
> So I've spent the last few days trying several things to recover the
> array. Assumption is the mother right?
>
> I had 3 arrays, /, /usr and /opt. I did some basic research at the
> various raid levels, and for some reason decided that f2 was good for /,
> and o2 for /usr. In that same trend I thought o2 was good for /opt as
> well. I was wrong. I was so sure I made it o2, that I ruled out the
> possibility it being f2. I did try various offsets, but never f2 with
> missing /dev/sdb6. I think i even tried f2 in the passed, but on sda6
> where i may have broke things.
>
> Short story short, it turns out it was 128k chunks, Far2 offset. The
> data actually is accessible from a dd-ed image looped to mdadm and that
> mounted. I will now recreate my md2 array, and copy the data over.
>
> Thank you for all advice and help in the past and again. You are an
> amazing dev and a good person.
>
> Oliver
>
