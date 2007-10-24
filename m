From: "John Stoffel" <john@stoffel.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Wed, 24 Oct 2007 10:00:34 -0400
Message-ID: <18207.20482.272516.461264@stoffel.org>
References: <18200.49267.763509.924873@stoffel.org>
	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	<18200.53593.687483.120827@stoffel.org>
	<1192810534.1666.68.camel@firewall.xsintricity.com>
	<18200.56684.14194.630264@stoffel.org>
	<1192813877.1666.79.camel@firewall.xsintricity.com>
	<18200.63987.514073.184865@stoffel.org>
	<471E7DC6.7050206@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471E7DC6.7050206@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: John Stoffel <john@stoffel.org>, Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Bill" == Bill Davidsen <davidsen@tmr.com> writes:

Bill> John Stoffel wrote:
>> Why do we have three different positions for storing the superblock?  

Bill> Why do you suggest changing anything until you get the answer to
Bill> this question? If you don't understand why there are three
Bill> locations, perhaps that would be a good initial investigation.

Because I've asked this question before and not gotten an answer, nor
is it answered in the man page for mdadm on why we have this setup. 

Bill> Clearly the short answer is that they reflect three stages of
Bill> Neil's thinking on the topic, and I would bet that he had a good
Bill> reason for moving the superblock when he did it.

So let's hear Neil's thinking about all this?  Or should I just work
up a patch to do what I suggest and see how that flies? 

Bill> Since you have to support all of them or break existing arrays,
Bill> and they all use the same format so there's no saving of code
Bill> size to mention, why even bring this up?

Because of the confusion factor.  Again, since noone has been able to
articulate a reason why we have three different versions of the 1.x
superblock, nor have I seen any good reasons for why we should have
them, I'm going by the KISS principle to reduce the options to the
best one.

And no, I'm not advocating getting rid of legacy support, but I AM
advocating that we settle on ONE standard format going forward as the
default for all new RAID superblocks.

John
