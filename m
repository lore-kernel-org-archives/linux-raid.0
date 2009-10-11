From: Anssi Hannula <anssi.hannula@gmail.com>
Subject: stuck in resync=DELAYED if other resyncing array is stopped
Date: Sun, 11 Oct 2009 22:51:52 +0300
Message-ID: <4AD23758.1030500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I had two recovery resyncs going on at the same time, with arrays
sharing devices. The resync in one array was progressing, while the
other was in DELAYED state (i.e. waiting for the first one to finish).
However, when I stopped the first array completely, the second one
remained in DELAYED state and was not waken up.

Unfortunately this was some time ago (I think it was 2.6.30.x) and I
forgot about it until now.

I quickly looked at the current git code and I don't see resync_wait
being wake_up()ed in the md stop codepath.
Maybe someone more familiar with the code can confirm+fix this..
Otherwise I can try to do some testing myself when I have time in a few
weeks.

-- 
Anssi Hannula
