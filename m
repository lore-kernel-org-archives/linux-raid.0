From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: Re: raid superblock checksum problem
Date: Tue, 26 Sep 2006 23:31:40 -0700
Message-ID: <CD68F2EC-E92B-4731-9695-A19C5E165A44@develooper.com>
References: <20060927082251.z2se9ux33pc0o40k@raudies.homeip.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060927082251.z2se9ux33pc0o40k@raudies.homeip.net>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Paulus <oliver@code-project.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sep 26, 2006, at 23:22, Oliver Paulus wrote:

> I cannot use the created raid device as "/" partition. I get the  
> following error
> in dmesg:
> "invalid superblock checksum on sda1"
> "invalid superblock checksum on sdb1"

Did you mkfs the md device?


  - ask

-- 
http://askask.com/  - http://develooper.com/


