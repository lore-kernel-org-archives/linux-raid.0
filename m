From: Michal Soltys <soltys@ziu.info>
Subject: Re: Question on hotplug SATA controllers
Date: Sat, 07 Jun 2008 09:20:17 +0200
Message-ID: <484A36B1.1040103@ziu.info>
References: <484963E0.4010009@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484963E0.4010009@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Apologies for yet another off-topic thread :)
> 
> controllers that fully support hotplug. By fully support I mean I can 
> pull a drive, have udev register it as missing, put it back in - have 
> the device node re-appear in /dev. To date I am not aware of any 
> consumer grade (i.e. can be found on newegg) controller/chipset which 
> can actually do this. Does such a card exist?
> 
> Thanks
> 

Everything intel since ich7, as well as, SIIs JMicron, Promises supports 
hotplug out of the box in modern linux (generally -  most of the 
hardware working under ahci driver in your linux).
