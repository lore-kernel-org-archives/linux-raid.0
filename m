From: antlists <antlists@youngman.org.uk>
Subject: Re: Requesting help repairing a RAID-6 array
Date: Sun, 29 Mar 2020 23:31:35 +0100
Message-ID: <fc847f59-b221-c97c-28d6-813f8d79f15f@youngman.org.uk>
References: <etPan.5e80defb.10afc736.32ba@crowston.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <etPan.5e80defb.10afc736.32ba@crowston.name>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: "crowston.name" <kevin@crowston.name>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/03/2020 18:45, crowston.name wrote:
> === START OF INFORMATION SECTION ===
> Device Model:     ST3000DM001-1CH166
> Serial Number:    Z1F50Y21
> Firmware Version: CC29

Seagate Barracuda :-( Not suitable as a raid drive.

Have you read https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

If you're not running that timeout script you are, unfortunately, a 
perfect example of why Barracudas aren't a good idea. If that script 
fixes most of your problems (it won't help you retrieve the array, but 
it *will* help you keep the array alive while you try to recover your 
data off it) then you need to replace all drives with more suitable ones 
asap - Ironwolves perhaps?

Cheers,
Wol
