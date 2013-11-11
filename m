From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommending RAID6 over RAID5 when doing mdadm --create
Date: Mon, 11 Nov 2013 02:56:37 -0600
Message-ID: <52809BC5.2010605@hardwarefreak.com>
References: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/11/2013 1:44 AM, Mikael Abrahamsson wrote:

> I believe this has been discussed before, but I would like to bring it
> up again.
> 
> I would like to see mdadm recommend RAID6 over RAID6 when using
> component drives that are 500GB or larger and ask if the user is really
> sure about using RAID5, plus a pointer to a webpage on the wiki
> informing the user about the trouble with RAID5 on large volumes with
> consumer or prosumer drives.
> 
> I am willing to contribute text to the webpage being pointed to.

Wikis change to regularly, too easily.  Networks can be down at times,
often the worst times.  See Murphy's Law.

It would be better to put this information in mdadm(8) and refer the
user there.

-- 
Stan





