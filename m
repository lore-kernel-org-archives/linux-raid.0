From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: simple question: where is internal bitmap stored?
Date: Wed, 13 May 2009 18:37:12 +1000
Message-ID: <4A0A86B8.5030905@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If I have a live raid and want to enable bitmap then I do
	mdadm --grow /dev/md0 --bitmap=internal
Does this bitmap use space in the already present header? If so then
does this mean that the headers have enough reserve for this? Why
not always use the bitmap then?

If it carves extra space from the device which already has data
(e.g. a fs) then surely this will be problematic.

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
