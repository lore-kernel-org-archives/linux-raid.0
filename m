From: Christian Pernegger <pernegger@gmail.com>
Subject: Feature request: ability to exchange drive without failing the old
	one
Date: Tue, 13 Oct 2009 02:40:45 +0200
Message-ID: <bb145bd20910121740n208e4c71v30520a7ea8b57d21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list!

Sometimes I want to exchange a drive in an array even if it hasn't
actually failed, e. g.
- in preperation for a grow operation: exchange-resync-exchange-resync-...-grow
- when removing old drives as part of regular maintenance
- ...

Currently one has to fail an active drive to trigger a resync to the
replacement (assuming it was added as a spare beforehand) and thus
suffer the loss of fault tolerance and performance until the sync is
complete.

Suggestion: allow adding drives as an explicit replacement for an
active one. The active drive would then be copied to the new one in
the background, effectively replacing the component device with a
mirror. Bonus points if the resulting setup is a valid mode of
operation and not just a temporary hack. I suppose one could see the
feature as a special case of the reshaping that's all the rage now :)

Thanks for listening,

Christian
