From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: write-refresh md array (feature request)
Date: Tue, 10 Sep 2013 15:19:05 -0300
Message-ID: <20130910181905.GC21530@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(please CC me on replies).

I've been in several situations where it would have been helpful to be able
to refresh weak sectors by rewriting the whole md raid component device,
without the need to increase array failure risk through a fail+remove+add
cycle for the component device.

How difficult would it be to implement a "refresh" as a Linux md driver
sync_action, pigging back on "check" ?

Are there any drawbacks to write-refreshing component devices?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
