From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Mon, 31 Jan 2011 20:31:38 -0500
Message-ID: <4D47627A.1080509@cfl.rr.com>
References: <4CF55680.5010703@cfl.rr.com> <20101201092508.7023f974@notabene.brown> <4CF81A16.2010606@cfl.rr.com> <20101203123615.6edce071@notabene.brown> <4CF860EB.7010005@cfl.rr.com> <20101209094354.4c6aaa93@notabene.brown> <4D01328D.9050503@cfl.rr.com> <4D46E6D7.2000205@cfl.rr.com> <20110131170349.GR343@caffeine.csclub.uwaterloo.ca> <4D470BCF.20508@cfl.rr.com> <20110131221252.GT343@caffeine.csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131221252.GT343@caffeine.csclub.uwaterloo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: The development of GNU GRUB <grub-devel@gnu.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, John Sheu <john.sheu@gmail.com>
List-Id: linux-raid.ids

On 01/31/2011 05:12 PM, Lennart Sorensen wrote:
> Well one of them stores the raid info at the end of the device, so that
> one offers no help for the bootloader at all.  I think the other stores

What do you mean help?

> it at 4KB in to the device if my memory serves me right.  Not sure if
> the first 4KB are left empty for other uses or not.

It is left empty afaik, which is the whole point of shifting it over to 4kb.

> It seems to me the simplest thing to do is to simply state in
> documentation that grub can not be installed on md raid if there is no
> partition table in use.  This doesn't mean people can't do it for purely
> data oriented drives, but for the drives with the boot laoder there
> are limitations.

Obviously doing nothing is the simplest thing one can do.  Instead I 
would like to do something and end up with a better, more functional 
system.  Hence my suggestion on WHAT to do and the existence of this 
entire thread.
