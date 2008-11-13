From: Ferg <ferg@scotgate.org>
Subject: Re: Tips for good hard drives for a home server
Date: Thu, 13 Nov 2008 12:25:35 +0000
Message-ID: <1E9B82E1-1C22-4BF6-A85B-B607AFBCB7CD@scotgate.org>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com> <A20315AE59B5C34585629E258D76A97C02A43936@34093-C3-EVS3.exchange.rackspace.com> <837a927a0811120631j4bf074d1s5eab70142a7173b2@mail.gmail.com> <3ECBDC05781B3D48ABD520A01ABF2F9B299C9ECE78@SE-EX008.groupinfra.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B299C9ECE78@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Andrew,

I think you are going to need to duck with such a statement:

On Nov13,2008, at 12:11, Henry, Andrew wrote:

>> Any reason you are using RAID 0 for your server? Normally when I  
>> think of a server reliability  comes to mind and RAID 0 doesn't  
>> offer any.
>> I'm assumming you make nightly or weekly backups?

> Im using RAID 0 because I am not willing to shell out for several  
> drives.  2 at once is my breaking point.  This is only a *home*  
> server, and in my opinion, I think im already being way more  
> conscious of reliability by choosing RAID 0 compared to average Joe  
> that goes for a Windows Home Server with a single hard drive

RAID 0 is actually less reliable than a single drive.  Since you lose  
the array when any of the component drives dies, then the  
"reliability" is equal to the "reliability" of the least reliable  
drive divided by the number of drives you have.....!

I've been watching this thread with interest as I'm about to replace a  
4 disc RAID10 SCSI array for a home server with similar SATA drives.   
I'm probably going to go with the Seagate Barracuda ES 1TB drives  
(ST31000340NS ). Bit expensive for a home server, and they do not have  
a reputation as being quiet, but they should last me a good while....!

Cheers
Chris

http://scotgate.org   AIM#fergycool   Skype#fergycool
"cease to exist, giving my goodbye, drive my car into the ocean, you  
think
I'm dead, but i sail away, on a wave of mutilation!"
