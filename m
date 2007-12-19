From: Russell Smith <russell.smith@ukd1.co.uk>
Subject: Re: Raid over 48 disks
Date: Wed, 19 Dec 2007 12:08:02 +0000
Message-ID: <476909A2.8030502@ukd1.co.uk>
References: <200712182350.lBINoMn17765@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200712182350.lBINoMn17765@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'Brendan Conoboy' <blc@redhat.com>, 'Norman Elton' <normelton@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy Watkins wrote:
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Brendan Conoboy
> } Sent: Tuesday, December 18, 2007 3:36 PM
> } To: Norman Elton
> } Cc: linux-raid@vger.kernel.org
> } Subject: Re: Raid over 48 disks
> } 
> } Norman Elton wrote:
> } > We're investigating the possibility of running Linux (RHEL) on top of
> } > Sun's X4500 Thumper box:
> } >
> } > http://www.sun.com/servers/x64/x4500/
> } 
> } Neat- 6 8 port SATA controllers!  It'll be worth checking to be sure
> } each controller has equal bandwidth.  If some controllers are on slower
> } buses than others you may want to consider that and balance the md
> } device layout.
>
> Assuming the 6 controllers are equal, I would make 3 16 disk RAID6 arrays
> using 2 disks from each controller.  That way any 1 controller can fail and
> your system will still be running.  6 disks will be used for redundancy.
>
> Or 6 8 disk RAID6 arrays using 1 disk from each controller).  That way any 2
> controllers can fail and your system will still be running.  12 disks will
> be used for redundancy.  Might be too excessive!
>
> Combine them into a RAID0 array.
>
> Guy
Sounds interesting!

Just out of interest, whats stopping you from using Solaris?

Though, I'm curious how md will compare to ZFS performance wise. There 
is some interesting configuration info / advice for Solaris here: 
http://www.solarisinternals.com/wiki/index.php/ZFS_Configuration_Guide 
esp for the X4500.


Russell
