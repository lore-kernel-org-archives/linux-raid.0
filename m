From: antlists <antlists@youngman.org.uk>
Subject: Re: rsync input/output errors during resyncing of RAID10 e-sata,
 share changed to read-only
Date: Tue, 9 Jun 2020 19:26:11 +0100
Message-ID: <a54042af-a97e-5de0-b75c-33cb2cb5df76@youngman.org.uk>
References: <CAFHi+KSxLugjBpj0vFdC6xJMQrnGUrHDamqA6BcyYBt51r+wAA@mail.gmail.com>
 <CAFHi+KRL2VfyiQxEPbPQRE8Kkaj1jO+FdUcPikJxFUPN514eRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFHi+KRL2VfyiQxEPbPQRE8Kkaj1jO+FdUcPikJxFUPN514eRg@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kudyba <rkudyba@fordham.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/06/2020 17:51, Robert Kudyba wrote:
> Disk /dev/sdf: 1.37 TiB, 1500301910016 bytes, 2930277168 sectors
> Disk model: ST31500341AS

Is this a Barracuda? ummmm :-(

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

Are you running that script that fixes timeouts?

When you get things sorted, you need to check all the SMARTs.

Cheers,
Wol
