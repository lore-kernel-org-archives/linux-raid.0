From: Gael Lams <g_lams@yahoo.com>
Subject: Re: hp lh3000 megaraid driver not working - problem solved
Date: Wed, 12 May 2004 12:59:44 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040512195944.2874.qmail@web40711.mail.yahoo.com>
References: <20040511210328.54055.qmail@web40705.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040511210328.54055.qmail@web40705.mail.yahoo.com>
To: Gael Lams <g_lams@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just wanted to explain how I solved my problem, in
case it could one day be of interest for someone.
I had to disable i2o on the raid adapter and to pass 2
parameters at boot time: acpi=oldboot and apic
--- Gael Lams <g_lams@yahoo.com> wrote:
> Good afternon, 
>   
> I'm trying to install suse professional 9.0 on an HP
> LH 3000 which has an integrated Netserver raid,
> which
> if I'm not woring is an oem ami megaraid
> I performed both a new installation and an upgrade
> from a SuSe 7 installation (which worked like a
> charme) but nohing to do. 
> 
> I also tried a "manual installation" with linuxrc
> loading by hand the 2 available megaraid module but
> the program keeps saying "trying to load module" and
> nothing happens
> 
> I searched the web and various mailing lists but
> wasn't able to find something that seemed to be
> relevant for me so any pointer would be greatly
> appreciated
> 
> Regards 
>   
> Gael 
> 
> 
> 	
> 		
> __________________________________
> Do you Yahoo!?
> Win a $20,000 Career Makeover at Yahoo! HotJobs  
> http://hotjobs.sweepstakes.yahoo.com/careermakeover 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html



	
		
__________________________________
Do you Yahoo!?
Yahoo! Movies - Buy advance tickets for 'Shrek 2'
http://movies.yahoo.com/showtimes/movie?mid=1808405861 
