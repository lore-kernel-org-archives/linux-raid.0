From: Brad Dameron <brad@seatab.com>
Subject: Re: building a disk server
Date: Tue, 29 Nov 2005 11:31:18 -0800
Message-ID: <1133292678.15856.7.camel@dhcpc226.office.pivotlink.com>
References: <7f55de720511281555s6b30355atf2b943b5148b8c37@mail.gmail.com>
	 <1133226093.4149.18.camel@dhcpc226.office.pivotlink.com>
	 <7f55de720511282105s19b6fc11r21de7f42a5a9874c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7f55de720511282105s19b6fc11r21de7f42a5a9874c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2005-11-28 at 22:05 -0700, Sebastian Kuzminsky wrote:
> On 11/28/05, Brad Dameron <brad@seatab.com> wrote:
> > Might look at a Areca SATA RAID controller. They support up to 24 ports
> > and has hardware level RAID capacity expansion. Or if you want to go
> > cheaper look at the 3ware controller and use it in JBOD. That way you
> > can get the Smart monitoring and hotplug.
> 
> Do you use the regular smartd?
> 
> The only hotplug disks I've used have been through USB, and that works
> great now days.  Does SATA behave the same way?
> 
> I prefer JBOD because I trust the Linux software RAID better than the
> hardware vendor's.  Last time I built a system with hardware RAID was
> about 2002 and access to the array was really slow, maybe it's better
> now...  That was a 3Ware 4xPATA controller, dont remember the model
> number.
> 
> 
> > Supermicro SC933T-R760 3u or SC932T-R760 rackmount Chassis with 15 SATA
> > Hot-Swap drive trays and triple redundant power supplies.
> > Any motherboard and CPU will do. I would recommend a AMD64 CPU with a
> > motherboard that has a PCI-X slot on it if possible. I used a Tyan S2468
> > with dual Athlon 2800's and 2GB.
> > A 3ware 9500S-12. Not the 9500S-12MI with this case. Or the new
> > 9550SX-12 which is much faster now.
> > 12 - 300GB Maxtor MaXLine III drives
> > 2 - Western Digital 36GB 10k drives
> 
> Thanks for the list!
> 
> Is Linux aware of the state of your power supplies at all?  It'd be
> nice to get an email when someone trips and pulls out one of the power
> cords....  Do you have each power supply plugged in to a different
> UPS?  :-)
> 

Please don't send to me directly. This could help someone else on the
list. 

3ware has Linux tools to monitor the drives or you. And their 9000
series cards are very fast in a RAID configuration. I actually use RAID5
with 1 hot-spare drive. Their older cards were kind of slow. I have a
few laying around here as well. 

No I do not believe that Linux is aware of the power supplies. They do
however beep when one is not plugged in. And I have seen a card for
windows that you can plug this into and notify you. But not sure of a
Linux version. The 3ware and Areca card's are very fast and reliable.
SATA is the future and expect it to replace SCSI in the next year or so
when SATA-3 comes out at 600MB/s bus and they start coming out with full
10k and 15k drives.

Brad Dameron
SeaTab Software
www.seatab.com

