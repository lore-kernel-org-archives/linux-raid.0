From: Phil Turmel <philip@turmel.org>
Subject: Re: Unable to (un)-grow raid6
Date: Tue, 8 Dec 2015 22:12:30 -0500
Message-ID: <56679C1E.1040908@turmel.org>
References: <4E26C335-DEDB-489E-B54E-A285273569A1@alkaline-solutions.com>
 <465BF0F5-B5C7-4C02-8EB5-552B959B8D29@alkaline-solutions.com>
 <56649C04.9000601@turmel.org>
 <9F08EE4D-B926-4F8F-9F9D-F9C7234959B4@alkaline-solutions.com>
 <5664A6E2.4070900@turmel.org>
 <BACF203A-3817-4F24-88B0-38713D9459D9@alkaline-solutions.com>
 <5664D042.9080401@turmel.org>
 <10980501-F73B-4A63-AF7D-D7100C9C6B72@alkaline-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10980501-F73B-4A63-AF7D-D7100C9C6B72@alkaline-solutions.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Waite <david@alkaline-solutions.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/08/2015 06:42 PM, David Waite wrote:
> Thanks for your help - it is now reshaping the array with sdia3 and
> sdib3 as hot spares.
> 
> It appears the version of mdadm on the NAS (3.1.4) is pretty old, and
> does not have a replace command - just marking disks as faulty. I
> will build and load in a newer version of mdadm. I assume there is no
> issue in doing this while a reshaping is going on?

No issue.  You don't even have to install it.  However, like most
features, there's a kernel part and a userspace part.  If the new mdadm
that supports --replace can't talk to the matching kernel part, it won't
work.

Either way, you can't actually do the --replace until the reshape finishes.

{Convention on kernel.org lists is to reply-to-all, trim replies, and
bottom post.  Please do.}

Phil
