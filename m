From: Luke Reeves <luke@neuro-tech.net>
Subject: Re: Adding a new mirror disk to RAID1 configuration
Date: Fri, 09 Jul 2004 16:23:11 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40EE55EF.9060806@neuro-tech.net>
References: <200407090509.i6959W316863@watkins-home.com> <40EE2994.1090402@neuro-tech.net> <40EE5338.6080802@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40EE5338.6080802@dgreaves.com>
To: David Greaves <david@dgreaves.com>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ah, I understand, that should work correctly.  Thanks David.

And yeah, the second box I configured today I actually did do it 
correctly :-)

	Luke

David Greaves wrote:
> no, no no :)
> 
> Install the second disk (hdc)
> build it as md1 RAID1 with a 'missing' disk this time
> copy the data over from md0
> get rid of md0
> add the first disk as the missing disk
> it will sync
> 
> don't do it again
> 
> David
