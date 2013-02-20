From: David Brown <david.brown@hesbynett.no>
Subject: Re: Usefulness of RAID 4
Date: Wed, 20 Feb 2013 08:56:45 +0100
Message-ID: <512481BD.1010903@hesbynett.no>
References: <D5F9E1BC-26C0-4585-9DD5-0C19570FBA17@colorremedies.com> <5123FF85.50105@hardwarefreak.com> <CBC74AA5-EA3C-4B35-B43E-9C1F12C864CE@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CBC74AA5-EA3C-4B35-B43E-9C1F12C864CE@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: stan@hardwarefreak.com, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/02/13 23:46, Chris Murphy wrote:
> 
> On Feb 19, 2013, at 3:41 PM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> 
>> On 2/18/2013 9:01 PM, Chris Murphy wrote:
>>> Assuming HDD only, is there broad use case for RAID 4 that RAID 5
>>> isn't equally or better suited for?
>>> 
>>> What about making the parity drive an SSD, keeping the other
>>> drives HDD?

Raid 4 has no good uses as a final format for a raid layout - raid 5 is
better in every way.

However, raid 4 /is/ useful as an intermediary format for md raid,
during operations like re-shaping and re-sizing.  It is more like a raid
5 with an unusual parity layout (md raid also supports raid 6 with a
number of different parity layouts for the same reason).

>> 
>> Why are you revisiting RAID-4?
> 
> Because it's offered in Fedora 18's GUI installer.

Fedora is a distribution aimed at experienced users and tinkerers, so it
tends to include all sorts of weird opinions in the installer - simply
because Linux supports them.  It will probably also have an option to
use the minix file system for your root file system.

> 
>> It's dead tech, decades ago.  It has no advantages over subsequent
>> RAID levels, yet significant handicap.
> 
> That's what I thought. But is it remotely practical/useful to use
> HDDs for data drives, and one SSD as the parity drive to eliminate
> the parity write bottleneck of RAID 4?
> 
> 
> Chris Murphy-- To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 

