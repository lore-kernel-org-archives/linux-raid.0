From: Colin McDonald <ce.mcdonald@gmail.com>
Subject: RAID 1 on a server with possible mad mobo
Date: Tue, 8 Mar 2005 13:19:45 -0500
Message-ID: <bbfa52890503081019478cb6cf@mail.gmail.com>
Reply-To: Colin McDonald <ce.mcdonald@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We have a production server that has apparently crashed and is not
getting to the point of booting.

It is a Fedora Core 3 install using md with a RAID 1 config with two
IDE disks on a Promise Ultra 133 controller. We may have to move it to
a completely different box.

Without taking up to much of y'alls time, what would be the best
solution for moving the RAID array over to a new box?

1. Fresh install on new disk and then pull the data off and startover
with a new RAID 1 config.
2. Try to boot off of the disks after they have been transferred into
the new machine? I know this will cause all kinds of problems with
kernel/devices, etc and probably won't work.

Are there any How-To's, Docs that discuss this. I have googled but
haven't had any joy.

Thanks

cm
