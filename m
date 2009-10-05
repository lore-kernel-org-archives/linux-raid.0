From: Drew <drew.kay@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 09:19:03 -0700
Message-ID: <c268e4660910050919x5cfc0fdbm5e42e2ec14957585@mail.gmail.com>
References: <c268e4660910050849mc4bba01ifbb1a57caf59c41a@mail.gmail.com>
	<177529.24520.qm@web38806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <177529.24520.qm@web38806.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> ... But no journalling for crash recovery?

Journalling is a function of the filesystem, not the block devices.
RAID is there to make sure you won't lose data if a physical disk
dies.



-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
