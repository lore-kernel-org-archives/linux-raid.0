From: Neil Brown <neilb@suse.de>
Subject: Re: Booting issue - rebooting also
Date: Tue, 18 Jul 2006 12:21:46 +1000
Message-ID: <17596.17850.157614.266359@cse.unsw.edu.au>
References: <44B6C404.1000307@vladoportos.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Vladimir Strycek on Friday July 14
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Strycek <vladoportos@vladoportos.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 14, vladoportos@vladoportos.sk wrote:
> Hi i have small problem when i booting i have md1 as /boot md2 as  swap 
> and md3 as / (root) and when it come to md3 it say something like "md3 
> has no identity information" i cant read it its go too fast... it 
> actualy dont affect system as far i can see but i dont like errors ta 
> boot... ;) also when i shutdown or reboot it say md3 cant be unmount 
> cause is bussy... it will shutdown/reboot but again there is that red 
> mark as error :)
> 
> Could be fixed ?

Show us you /etc/mdadm.conf please.

NeilBrown
