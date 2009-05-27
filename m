From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: FW: Detecting errors on the RAID disks.
Date: Thu, 28 May 2009 07:35:28 +1200
Message-ID: <4A1D9600.5020109@sauce.co.nz>
References: <3D76E016F4A2A749A1EB1A3FD83E22BC0285F2F4@uk-email.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D76E016F4A2A749A1EB1A3FD83E22BC0285F2F4@uk-email.terastack.bluearc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Jackson <sjackson@bluearc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Simon Jackson wrote:
> I have been looking for a way of detecting whether disks used in RAID sets have had errors that might indicate the drive is failing..  

smartd, while not foolproof, offers some assistence here:

http://smartmontools.sourceforge.net/

Regards,

Richard
