From: Redeeman <redeeman@metanurb.dk>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 05 Dec 2008 22:12:38 +0100
Message-ID: <1228511558.16555.84.camel@localhost>
References: <1228510833.16555.76.camel@localhost>
	 <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>
	 <1228511195.16555.78.camel@localhost>
	 <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-12-05 at 16:09 -0500, Justin Piszcz wrote:
> 
> On Fri, 5 Dec 2008, Redeeman wrote:
> 
> > On Fri, 2008-12-05 at 16:02 -0500, Justin Piszcz wrote:
> >>
> >> On Fri, 5 Dec 2008, Redeeman wrote:
> >>
> >>> Hello.
> >>>
> >>> I was looking at the PDFs linked to from the wiki, and found this:
> >>> http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
> >>>
> >>> More specifically, section 4, starting on page 8.
> >>>
> >>> Am I understanding this correctly, in that with raid6, linux is capable
> >>> of detecting if the content on 1 disk is corrupted, and reconstruct it
> >>> from the remaining disks?
> >>
> >> I ran md/raid6 for awhile, do you mean remap the bad sector on the fly?
> >> Linux/md raid does not do this afaik.
> >
> > No, i mean, if one disk does silent corruption
> 
> What would the error look like?  Both md/Linux & in the 3ware manual 
> recommend you run a 'check' across the raid at least once a week 
> (3ware/raid-verify) and md/Linux in Debian runs a check once a month I 
> believe to eliminate these issues.
> 
> If you are asking whether a read error of a latent sector from the one 
> disk will result it reading the data from the second disk that is a good
> question.

im asking, if one disk in a raid6 setup suddenly decides to flip a few
bits in some bytes, will it be able to detect that in a scan, and
correct it? i cant see how it can do it on raid5, but maybe raid6?
> 
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

