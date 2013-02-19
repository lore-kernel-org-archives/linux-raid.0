From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Usefulness of RAID 4
Date: Tue, 19 Feb 2013 16:07:54 -0700
Message-ID: <EEEFE81B-5044-4650-ADA6-70F054AB5261@colorremedies.com>
References: <D5F9E1BC-26C0-4585-9DD5-0C19570FBA17@colorremedies.com> <5123FF85.50105@hardwarefreak.com> <CBC74AA5-EA3C-4B35-B43E-9C1F12C864CE@colorremedies.com> <5124039E.1040900@hardwarefreak.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5124039E.1040900@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 19, 2013, at 3:58 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
> Lines from the 1990 submarine warfare film "Hunt for Red October" are
> applicable here:
> 
> Ryan:  "Could you launch an ICBM horizontally?"
> Tyler: "I guess you could, but why would you want to?"

Trust me, I've been saying this a lot about user requests for esoteric features to the degree my eyeballs are getting sore from rolling so much. If I had a parrot, it would know 7 different inflections for saying WTF, and not the acronym.

Here's another one for you: RAID 0+1 as an install option instead of 10? Yes you could use 0+1 to do a three disk setup, that's the only thing it seems to bring to the table. e.g. stripe two SSD's, then mirror them with one suitably sized HDD? Why would you want to? You're too cheap to do a RAID 10 with four SSDs?

Chris Murphy