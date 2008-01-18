From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: Re: 3ware and erroneous multipathing - duplicate serial numbers (was: 3ware and dmraid)
Date: Fri, 18 Jan 2008 11:54:29 -0800
Message-ID: <EAA76A37-245F-4C22-9AB3-3CFC6F32061F@develooper.com>
References: <A2C96114-A87C-493B-A94D-4DCC80A17F95@develooper.com> <34DD6926-09BB-40FE-995E-C0C6796FE89C@develooper.com> <20080118123358.GA6311@redhat.com>
Mime-Version: 1.0 (Apple Message framework v915)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080118123358.GA6311@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: mauelshagen@RedHat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 18, 2008, at 4:33 AM, Heinz Mauelshagen wrote:

>> Much later I figured out that "dmraid -b" reported two of the disks  
>> as
>> being the same:
>
> Looks like the md sync duplicated the metadata and dmraid just spots
> that duplication. You gotta remove one of the duplicates to clean  
> this up
> but check first which to pick in case the sync was partial only.


The "event" counter is the same on both; is that what I should look for?

Is there a way to reset the dmraid metadata?   I'm not actually using  
dmraid, I use "regular software raid" so I think I just need to reset  
the dmraid data...


  - ask

-- 
http://develooper.com/ - http://askask.com/


