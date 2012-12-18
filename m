From: Alex Pientka <alex.pientka@gmail.com>
Subject: super slow reshape speed after power failure
Date: Tue, 18 Dec 2012 16:33:30 -0500
Message-ID: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently I am converting my 6x 2tb raid5 from 256 chunk down to 4k.
While the reshape was running it was running around 4mb/s, which is
slow to begin with.

Yesterday we lost power and afte the system came back up, I was able
to bring the raid back up and running via 'export
MDADM_GROW_ALLOW_OLD=1`. The current issue is that the reshape is
running with only 700kb/s.

Any ideas?

Alex
