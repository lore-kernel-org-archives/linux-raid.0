From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Ubuntu's ReliableRaid document
Date: Mon, 29 Mar 2010 07:55:16 +0200
Message-ID: <4BB040C4.4070506@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

Has anyone on this list seen/reviewed the Ubuntu document at

https://wiki.ubuntu.com/ReliableRaid

My concerns are the following (but I have to prefix them with the
admission that my knowledge is too limited to be sure whether my
concerns are valid):

- The document comes across as being dismissive of some of the
  mdadm auto-assembly functionality, although this may be
  specific to the way in which mdadm is/was being used in Ubuntu.

- Some of the solutions to the identified problems appear
  dangerous. Example: unclear policy with regard to HOMEHOST in
  the absence of an mdadm.conf file or continued support of the
  use cases HOMEHOST was intended for.
 
- Suggestion that a configuration file might still be needed in
  order to capture RAID dependencies (such as on lvm and crypt),
  and that this file might be auto-generated. The discussion then
  goes on to say how this would be done based on major/minor
  numbers, which I believe run the risk of not being stable
  across boots.

I really hope that my concerns are unfounded, and I'd feel a lot
better if I were told so on this list.

Thanks, Jan

