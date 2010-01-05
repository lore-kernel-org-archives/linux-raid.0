From: Alessandro Baretta <alexbaretta@gmail.com>
Subject: Linear mode: array size is less than sum of sizes
Date: Tue, 5 Jan 2010 19:21:25 +0100
Message-ID: <f4143ac21001051021o45110f1fi833fc03bf9bae4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys.

I have a bizarre problem. Hopefully someone will provide some insight.

I would like to wrap my NTFS Windows XP partition into a virtual hard
disk for use with virtualization tools such as XEN or KVM. In order to
turn a partition into a virtual hard disk I must prepend enough space
at the beginning to allow space for the MBR and the partition table.
The idea I have is to create a little partition (/dev/sda5) on the
tail of my hard drive and use the md driver in linear mode to prepend
this to the NTFS partition (/dev/sda1). The resulting md device should
appear to Windows as a real hard drive, with its own MBR and partition
table.

I am using the following command to create the md device:

mdadm --build /dev/md0 -l linear -n2 /dev/sda5 /dev/sda1

The md device gets created properly and can be used with fdisk to
create a partition table. However, the size of the md device, as
reported by fdisk,  does not match the sum of the size of the
constituent block devices, always as reported by fdisk.

Here is a table showing the start and end sectors and the computed and
reported sizes of the two constituent partitions, sda1 and sda5, and
of the md device.

block dev		reported size	start			end			computed size		delta
/dev/sda1		241797953			63	241798015	241797953		0
/dev/sda5			16002	491797908	491813909		16002		0
/dev/md0		241813888							241813955		-67

As you can see the computed size is 67 sectors less than the reported
size. What happened to those sectors? They are surely not used to
store superblocks, as the --build command does not create superblocks.
If they are used for the md driver's magic, do they all come from the
first device of the array or are they distributed on both? All in all,
how safe (or unsafe) is my approach to virtualizing Windows XP on my
Linux box?

Thank you in advance for any help you can provide.

Alex
