From: Lars Ehrhardt <0104@ng.h42.de>
Subject: mdadm --manage --run stops a running array
Date: Wed, 07 Jan 2004 15:26:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FFC1701.1000705@ng.h42.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was creating a documentation about a local raid setup and typed
"mdadm --manage --run /dev/md1"
This was on a running array and the command returned:
mdadm: failed to run array "/dev/md1": Device or ressource busy.

I thought, alright, this makes sense /dev/md1 is already started and
mounted as /, so running it again does not work.

Unfortunately I was not able to do anything useful after that, since all
shell commands, like ls failed. Investigating this a bit on a
testmachine I found out that the raid array was shut-down and marked as
clean due to this run command. So, what happened was that the / fs was
still mounted but the raid-device was not running anymore and thus I
could not do anything useful with the system.

I've tested this on two different machines, running kernel 2.4.23 with
the grsecurity patch.

Is this a bug or expected? In my opinion the run command should not stop
an already running (and mounted) array.

Kind regards

Lars



