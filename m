From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Two-disk RAID5?
Date: Thu, 04 May 2006 21:18:57 -0400
Message-ID: <445AA801.6050404@tmr.com>
References: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com> <Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org> <20060501171128.GA18811@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060501171128.GA18811@harddisk-recovery.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Jon Lewis <jlewis@lewis.org>, "Jansen, Frank" <fjansen@egenera.com>, Tuomas Leikola <tuomas.leikola@gmail.com>, John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Erik Mouw wrote:

>On Wed, Apr 26, 2006 at 03:22:38PM -0400, Jon Lewis wrote:
>  
>
>>On Wed, 26 Apr 2006, Jansen, Frank wrote:
>>
>>    
>>
>>>It is not possible to flip a bit to change a set of disks from RAID 1 to
>>>RAID 5, as the physical layout is different.
>>>      
>>>
>>As Tuomas pointed out though, a 2 disk RAID5 is kind of a special case 
>>where all you have is data and parity which is actually also just data. 
>>    
>>
>
>No, the other way around: RAID1 is a special case of RAID5.
>
No it isn't. If you have N drives in RAID1 you have N independent copies 
of the data and no parity, there's just no corresponding thing in RAID5, 
which has one copy of the data, plus parity. There is no special case, 
it just doesn't work that way. Set N>2 and report back.

Sorry, I couldn't find a diplomatic way to say you're completely wrong.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

