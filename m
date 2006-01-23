From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: cpu consumption
Date: Mon, 23 Jan 2006 18:08:15 -0500
Message-ID: <200601232308.k0NN8Kq32567@www.watkins-home.com>
References: <43D55876.5020800@ula.ve>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D55876.5020800@ula.ve>
Sender: linux-raid-owner@vger.kernel.org
To: 'Gilberto Diaz' <gilberto@ula.ve>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Gilberto Diaz
} Sent: Monday, January 23, 2006 5:28 PM
} To: linux-raid@vger.kernel.org
} Subject: cpu consumption
} 
} Hello Everybody
} 
}    I have checked the list archive but I could not find any message that
} help. So I'm asking for help here. I have a Sun storege with 12 sata
} hard disks connected to a normal PC using a QLogic ISP2300 host adapter
} card. I have configured 6 raid1, (2 hard disk each). I excecuted the
} following commands to create all of the them
} 
} mdadm --create --verbose /dev/md1 --level=raid1 --raid-devices=2
} /dev/sda /dev/sdb
} mdadm --create --verbose /dev/md2 --level=raid1 --raid-devices=2
} /dev/sdc /dev/sdd
} mdadm --create --verbose /dev/md3 --level=raid1 --raid-devices=2
} /dev/sde /dev/sdf
} mdadm --create --verbose /dev/md4 --level=raid1 --raid-devices=2
} /dev/sdg /dev/sdh
} mdadm --create --verbose /dev/md5 --level=raid1 --raid-devices=2
} /dev/sdi /dev/sdj
} mdadm --create --verbose /dev/md6 --level=raid1 --raid-devices=2
} /dev/sdk /dev/sdl
} 
} Here is my /etc/mdadm/mdadm.conf file
} 
} DEVICE /dev/sd[abcdefghijkl] /dev/md1 /dev/md2 /dev/md3 /dev/md4
} /dev/md5 /dev/md6
} ARRAY /dev/md1 devices=/dev/sda,/dev/sdb
} ARRAY /dev/md2 devices=/dev/sdc,/dev/sdd
} ARRAY /dev/md3 devices=/dev/sde,/dev/sdf
} ARRAY /dev/md4 devices=/dev/sdg,/dev/sdh
} ARRAY /dev/md5 devices=/dev/sdi,/dev/sdj
} ARRAY /dev/md6 devices=/dev/sdk,/dev/sdl
} 
}    The problem is that the following proccesses are using a lot of cpu
} time.
} 
}     md1_raid1
}     md1_resync
}     ......
}     md6_raid1
}     md6_resync
} 
}     Here is a sample of the uptime command
} 
} 17:54:16 up  5:48,  2 users,  load average: 5.02, 5.05, 5.26

What is the CPU load?  The above does not reflect CPU usage.
I beleve it reports on average outsanding IOs.  With 6 arrays syncing, I
would have expected 6 or 12.

Run "top", or "sar -u 10 10" to see CPU usage.

Guy
} 
}     Does anybody have an idea what is the problem? Thank a lot in advance
} 
} Best regards
} Gilberto Diaz
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

