From: Pekka Aleksi Knuutila <zur@edu.lahti.fi>
Subject: raidstart fails if the first disk of an array is unusable
Date: Wed, 21 Aug 2002 19:25:15 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020821162515.GY14237@edu.lahti.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  Hi. I couldn't find out who currently maintains raidtools, hopefully
this patch will find it's way to him/her via this list.

  Following a Debian bug report about raidtools' strange behaviour,
Pontus Fuchs found and fixed the cause for a problem that you possibly
have experienced: raidstart won't start an array if it can't read the
superblock from the disk that is marked first in raidtab.

  

  (Please CC me, I'm not on the list)


