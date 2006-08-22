From: Gregory Seidman <gsslist+linuxraid@anthropohedron.net>
Subject: Re: RAID over Firewire
Date: Tue, 22 Aug 2006 19:35:28 -0400
Message-ID: <20060822233527.GA27803@anthropohedron.net>
References: <44EB94BE.8080907@sauce.co.nz>
Reply-To: gsslist+linuxraid@anthropohedron.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44EB94BE.8080907@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 23, 2006 at 11:35:26AM +1200, Richard Scobie wrote:
} Has anyone had any experience or comment regarding linux RAID over ieee1394?
} 
} As a budget backup solution, I am considering using a pair of 500GB 
} drives, each connected to a firewire 400 port, configured as a linear 
} array, to which the contents of an onboard array will be rsynced weekly.
} 
} In theory, throughput performance should not be an issue, but it would 
} be great to hear from somone who has done this.

My main concern has been redundancy rather than performance, but I have had
no issues with my setup: 2x250GB FW 400 drives running LVM on dm_crypt on 
RAID1. This is my home IMAP(S)/HTTP(S)/NFS/shell server. I've recently set
up the same thing for my mother. I'm really happy with it.

} Regards,
} Richard
--Greg

