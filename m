From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Kernels and MD versions (was: md: Introduction - raid5 reshape
 mark-2)
Date: Thu, 9 Feb 2006 11:07:48 -0700 (MST)
Message-ID: <Pine.LNX.4.64.0602091105270.27023@filesrv1.baby-dragons.com>
References: <20060124112626.4447.patches@notabene> <43E8D53E.4010202@idgmail.se>
 <17386.47069.138562.339803@cse.unsw.edu.au> <43EAE299.9000508@ucolick.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43EAE299.9000508@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Patrik ,

On Wed, 8 Feb 2006, Patrik Jonsson wrote:
> Neil Brown wrote:
>> I always make them against the latest -mm kernel, so that would be a
>> good place to start.  However things change quickly and I can't
>> promise it will apply against whatever is the 'latest' today.
>>
>> If you would like to nominate a particular recent kernel, I'll create
>> a patch set that is guaranteed to apply against that. (Testing is
>> always appreciated, and well worth that small effort on my part).
>
> I find this is a major problem for me, too. Even though I try to stay up
> to date with the md developments, I have a hard time piecing together
> which past patches went with which version, so if I get a recent version
> I don't know which patches need to be applied and which are already in
> there.
>
> My suggestion is that Neil, should he be willing, keep a log somewhere
> which detail kernel version and what major updates in md functionality
> go along with it. Something like
> 2.6.14         raid5 read error correction
> 2.6.15         md /sys interface
> 2.6.16.rc1     raid5 reshape
> 2.6.16.rc2-mm4 something else cool
>
> it would include the released kernels and the previews of the current
> kernel. That way, say I see that the latest FC4 kernel is 2.6.14, I
> could look and see that since the raid5 read error correction was
> included, I don't have to go looking for the patches.
>
> Maybe this is too much hassle (or maybe it's already out there
> somewhere) but I'm thinking simple, and I think it would give a
> high-level overview of the development for us who are not intimately
> involved in every kernel version.
 	Iirc ,  The git/snv/cvs repositories 'can' contain this
 	information .  Neil (as you say , if willing) can pull the
 	kernel versions & Notes for his submissions from the
 	repository .   Hth ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
|  http://www.asteriskhelpdesk.com/cgi-bin/astlance/r.cgi?babydr   |
+------------------------------------------------------------------+
