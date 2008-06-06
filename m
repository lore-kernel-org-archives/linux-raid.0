From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Question on hotplug SATA controllers
Date: Fri, 06 Jun 2008 18:20:48 +0200
Message-ID: <484963E0.4010009@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Apologies for yet another off-topic thread :)

Since there has been some discussion about not-quite-server grade hardware, I 
would like to ask about your experience with SATA controllers that fully 
support hotplug. By fully support I mean I can pull a drive, have udev 
register it as missing, put it back in - have the device node re-appear in 
/dev. To date I am not aware of any consumer grade (i.e. can be found on 
newegg) controller/chipset which can actually do this. Does such a card exist?

Thanks

Peter
