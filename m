From: "John Stoffel" <john@stoffel.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 11:46:33 -0400
Message-ID: <18200.53593.687483.120827@stoffel.org>
References: <18200.49267.763509.924873@stoffel.org>
	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:

Justin> On Fri, 19 Oct 2007, John Stoffel wrote:

>> 
>> So,
>> 
>> Is it time to start thinking about deprecating the old 0.9, 1.0 and
>> 1.1 formats to just standardize on the 1.2 format?  What are the
>> issues surrounding this?
>> 
>> It's certainly easy enough to change mdadm to default to the 1.2
>> format and to require a --force switch to  allow use of the older
>> formats.
>> 
>> I keep seeing that we support these old formats, and it's never been
>> clear to me why we have four different ones available?  Why can't we
>> start defining the canonical format for Linux RAID metadata?
>> 
>> Thanks,
>> John
>> john@stoffel.org
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 

Justin> I hope 00.90.03 is not deprecated, LILO cannot boot off of
Justin> anything else!

Are you sure?  I find that GRUB is much easier to use and setup than
LILO these days.  But hey, just dropping down to support 00.09.03 and
1.2 formats would be fine too.  Let's just lessen the confusion if at
all possible.

John
