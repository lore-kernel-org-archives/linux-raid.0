From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Help understanding the root cause of a member dropping out of
  a  RAID 1 set.
Date: Sat, 15 Aug 2009 08:56:11 +1200
Message-ID: <4A85CF6B.5060705@sauce.co.nz>
References: <ABFC24E4C13D81489F7F624E14891C860BF9A409@uk-ex-mbx1.terastack.bluearc.com>	 <a43edf1b0908130913x238b33ecref5a3d070bf3cb16@mail.gmail.com>	 <64960.78.86.108.203.1250180799.squirrel@www.yuiop.co.uk> <b95c1fdd0908140609jac48ba9u595f839d3d167293@mail.gmail.com> <4A8599E0.5000604@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A8599E0.5000604@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: =?ISO-8859-2?Q?Pawe=B3_Brodacki?= <pawel.brodacki@googlemail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson wrote:

> What is the operator's most likely response to seeing the SATA bus 
> reset? She's going to re-add the drive assuming it was a transient 
> error. If we could make this happen automatically, we could close a 

I'd like to think a better response would be to use smartctl on the 
drive  to examine it for signs of internal errors first...

Regards,

Richard
