From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Spares Missing event in case of spare group?
Date: Mon, 20 Apr 2009 21:02:35 +0200
Message-ID: <49ECC6CB.7050107@computer.org>
References: <49EB4B07.9050208@computer.org> <0ad180f4fb306d79e27eb9c822acdbaf.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0ad180f4fb306d79e27eb9c822acdbaf.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

NeilBrown wrote:
> Yes.  Remove the "spares=1" from each line.
> The sole effect of this text is to tell --monitor to expect a spare, and
> to complain if no spare is found.

Many thanks. I hadn't picked that up from the manpage, so here is a 
patch for your consideration:


diff --git a/mdadm.conf.5 b/mdadm.conf.5
index 40295be..b67bec4 100644
--- a/mdadm.conf.5
+++ b/mdadm.conf.5
@@ -135,6 +135,7 @@ this is mainly for compatibility with the output of
  .TP
  .B spares=
  The value is a number of spare devices to expect the array to have.
+The sole use of this keyword and value is as follows:
  .B mdadm \-\-monitor
  will report an array if it is found to have fewer than this number of
  spares when
