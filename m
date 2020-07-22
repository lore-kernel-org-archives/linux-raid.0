From: antlists <antlists@youngman.org.uk>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
Date: Wed, 22 Jul 2020 23:00:25 +0100
Message-ID: <0f935586-7d2f-02b9-9955-ab160dd4017f@youngman.org.uk>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Vojtech Myslivec <vojtech@xmyslivec.cz>, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Michal Moravec <michal.moravec@logicworks.cz>
List-Id: linux-raid.ids

On 22/07/2020 21:47, Vojtech Myslivec wrote:
> - RAID6 over 6 HDD and 1 LV as write journal (md1)
>      - This is the affected device

What hard drives do you have?

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

Dunno whether that is your problem, but it's one of the first things to 
check.

Cheers,
Wol
