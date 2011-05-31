From: "Pol Hallen" <raid1@fuckaround.org>
Subject: rebuild after reboot
Date: Tue, 31 May 2011 23:55:27 +0200 (CEST)
Message-ID: <d56d467d17b2470abebd7d02386f886f.squirrel@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks :-)

Yesterday I changed a fail disk, after complete recovery my raid was
perfectly. I rebooted my os and at start-up mdadm was again in recovery
mode (one disk fail)

Now I ask to myself, I have to do mdadm --examine --scan >>
/etc/mdadm/mdadm.conf everytimes I change a disk? or only when create a
new raid?

Why after reboot mdadm recovery again the array?

what is the problem?

thanks! :-)

Pol

