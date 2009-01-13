From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: southbridge/sata controller performance?
Date: Tue, 13 Jan 2009 14:28:39 -0600
Message-ID: <20090113202839.GB31265@sewage.raw-sewage.fake>
References: <20090103193429.GA17462@sewage.raw-sewage.fake> <495FC67A.2030201@gmail.com> <alpine.DEB.1.10.0901040451520.18797@p34.internal.lan> <20090104194023.GB10174@sewage.raw-sewage.fake> <496123ED.5050809@gmail.com> <20090105032728.GA24328@sewage.raw-sewage.fake> <20090105070806.GA3910@rap.rap.dk> <20090105142120.GA963@sewage.raw-sewage.fake> <20090105161147.GA9561@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IrhDeMKUP4DT/M7F"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090105161147.GA9561@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld J?rn Simonsen <keld@dkuug.dk>
Cc: Roger Heflin <rogerheflin@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2009 at 05:11:47PM +0100, Keld J?rn Simonsen wrote:
> On Mon, Jan 05, 2009 at 08:21:20AM -0600, Matt Garman wrote:
> > On Mon, Jan 05, 2009 at 08:08:07AM +0100, Keld J?rn Simonsen wrote:
> > > What about CPU usage?
> > 
> > I didn't watch that while running the test, but I can certainly
> > re-run them.  Is watching top the best way measure CPU usage, or
> > is there a better/more precise (and scriptable) way to capture
> > CPU usage for a process or group of processes?
> 
> I would  use iostat on a reasonably otherwise quiet system.

OK, see attached script.  It kicks off iostat with a 1 second
repeating interval in the background, runs either dd or bonnie, then
averages the iostat results.  This scheme should give a reasonable
approximation of system load during such a test.

(Side note: it would be nice to have a shell program like "time",
that returns the CPU usage for the process that follows the command.
E.g. "cputime <my program>", and when <my program> finishes you get
output similar to the iostat CPU info.)

> > > What happens when you put it into one or more raids, what are
> > > then your combinde performance? Did you experiment with
> > > different raid types?
> > 
> > I was only doing read tests at the raw sata device level, so the
> > actual raid shouldn't have made a difference.  Although as an
> > afterthought I realized could run the script at the md-device level.
> > 
> > Plus, I have semi-valuable data on these raids, and don't want to go
> > messing with them at this point!  :)
> 
> I see. It is just that your choice of raid could affect the
> performance and thus the need for southbridge bandwidth. Anyway it
> would be interesting to see how much you could get out of your
> system with a live fs.

The script does the dd test as before, but can now also do single or
parallel bonnie++ runs.

If I didn't mention this, the machine specs are: Intel DQ35JO
motherboard (Q35 northbridge, ICH9DO southbridge), E5200 CPU, 4 GB
RAM.  md0 is four WD 7200rpm 750 GB drives on the built-in SATA
controller (ICH9); md1 is four WD RE2 5400rpm 1 TB drives on two
2-port SATA PCIe cards.  Both filesystems are XFS (created with
ubuntu 8.04 server's defaults).

I'll be swapping out this hardware for the AMD solution soon: AMD
740G northbridge, SB700 southbridge/SATA controller, 4 GB RAM and
4850e CPU.  I'll be dropping the 4x750 array and using only the
4x1TB array on the native SATA controller.  (And FWIW, in the more
distant future, I'll probably upgrade this to a six disk raid-6
scheme using linux md.)

Let me know if my script can be enhanced or upgraded in any way...
or if I overlooked anything.

EDIT: just before sending I checked the linux-raid FAQ, and it
mentions the tiobench (Threaded I/O tester) program.  Has anyone
played with this?  I'm guessing it's more sophisticated than my
little hack job.  <shrug>

Here's the results from my md1 array:

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid5 sdb1[0] sdd1[3] sdc1[2] sde1[1]
      2930279808 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md0 : active raid5 sdf1[0] sdi1[3] sdh1[2] sdg1[1]
      2197715712 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

$ sudo ~/python/sata_performance.py -d /dev/sd[bcde]
Running dd benchmark(s)...
dd for /dev/sdd: 13107200000 bytes (13 GB) copied, 173.099 s, 75.7 MB/s
dd for /dev/sde: 13107200000 bytes (13 GB) copied, 172.1 s, 76.2 MB/s
dd for /dev/sdb: 13107200000 bytes (13 GB) copied, 171.922 s, 76.2 MB/s
dd for /dev/sdc: 13107200000 bytes (13 GB) copied, 172.903 s, 75.8 MB/s
ios avg: user=0.17, nice=0.00, sys=29.55, iowait=60.26, steal=0.00, idle=10.02

$ ~/python/sata_performance.py -b 1
Running bonnie++ benchmark(s)...
bonnie instance 0 results:
Writing a byte at a time...done
Writing intelligently...done
Rewriting...done
Reading a byte at a time...done
Reading intelligently...done
start 'em...done...done...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.93c       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
septictank       8G  1038  94 100356  29 48513  15  2245  98 112360  17 283.5   5
Latency             14914us    1649ms     645ms   18961us   75485us   70498us
Version 1.93c       ------Sequential Create------ --------Random Create--------
septictank          -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16  1945  14 +++++ +++  7122  48  5330  46 +++++ +++  7046  49
Latency             50418us      66us   94561us   74528us      29us   27207us
1.93c,1.93c,septictank,1,1231867303,8G,,1038,94,100356,29,48513,15,2245,98,112360,17,283.5,5,16,,,,,1945,14,+++++,+++,7122,48,5330,46,+++++,+++,7046,49,14914us,1649ms,645ms,18961us,75485us,70498us,50418us,66us,94561us,74528us,29us,27207us


ios avg: user=0.42, nice=0.00, sys=16.02, iowait=15.99, steal=0.00, idle=67.57



--IrhDeMKUP4DT/M7F
Content-Type: text/x-python; charset=us-ascii
Content-Disposition: attachment; filename="sata_performance.py"

#!/usr/bin/python
# vim:textwidth=0 nowrap

# Simple program that attempts to determine SATA controller/southbridge
# performance.
#
#   - Performs parallel block device reads using dd.  For example, does raw
#     read performance decrease when reading from multiple drives?
#   - Can also spawn concurrent bonnie++ instances.
#   - Records continuous iostat output while running dd or bonnie, and averages
#     the results to give an approximate CPU load measurement.
#
# Developed using Python 2.5.2 on Linux.
#
# Author: Matt Garman <matthew.garman@gmail.com>
#
# License: Public Domain

import re, os, sys, getopt, subprocess, signal, tempfile

# run-time configuration/global parameters
rtcfg = {
    'iostat'     : '/usr/bin/iostat',
    'ios_opts'   : [ '-c', '-m', '1' ],
    'dd'         : '/bin/dd',
    'dd_bs'      : '128k',
    'dd_count'   : '100000',
    'bonnie'     : '/usr/local/sbin/bonnie++',
}


##############################################################################
def usage():
    print """
sata_performance.py - (attempt to) assess SATA controller/southbridge 
                      performance
Usage: %s -b <n>
       %s -d <devices>

  OPTIONS:
      -b    run bonnie++ benchmarks
            <n> is number of parallel instances of bonnie++ to run
      -d    run dd read benchmarks
            <devices> is a list of block devices from which we'll read
      -h    show this help

    """ % (sys.argv[0], sys.argv[0])


##############################################################################
def main():
    global rtcfg
    run_dd = False
    n_bonnie_instances = 0
    optstr = "dhb:"
    try:
        opts, args = getopt.getopt(sys.argv[1:], optstr)
    except getopt.GetoptError, err:
        print str(err)
        usage()
        sys.exit(2)
    for o, a in opts:
        if o == '-b': n_bonnie_instances = int(a)
        if o == '-d': run_dd = True
        if o == '-h':
            usage()
            sys.exit()

    # basic input/parameter checking
    #if n_bonnie_instances > 0 and run_dd:
    #    print >>sys.stderr, 'ERROR: use -b OR -d, but not both (use -h for help)'
    #    sys.exit()

    # first kick off iostat
    ios_cmd  = [ rtcfg['iostat'] ] + rtcfg['ios_opts']
    #print "ios_cmd = " + str(ios_cmd)
    ios_proc = subprocess.Popen(ios_cmd, shell=False, \
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    if n_bonnie_instances > 0:
        run_bonnie_benchmarks(n_bonnie_instances)

    if run_dd:
        devices = list()
        if len(args) < 1:
            print >>sys.stderr, 'ERROR: no devices specified, use -h for help'
            os.kill(ios_proc.pid, signal.SIGTERM)
            sys.exit(1)
        else:
            for dev in args[0:]: devices.append(dev)
            run_dd_benchmarks(devices)

    # iostat: kill, get output, parse output
    #ios_proc.terminate() # need version 2.6
    os.kill(ios_proc.pid, signal.SIGTERM)
    ios_stdout, ios_stderr = ios_proc.communicate()
    parse_iostat_output(ios_stdout)
    sys.exit()


##############################################################################
def parse_iostat_output(iosdata):
    user = list()
    nice = list()
    system = list()
    iowait = list()
    steal = list()
    idle = list()
    is_first = True
    #print "iosdata = \"\n" + iosdata + "\n\""
    lines = iosdata.split('\n')
    for line in lines:
        line = line.strip()
        #print "line=\"" + line + "\""
        if len(line) == 0: continue
        if re.compile('^\d').match(line):
            # skip the first iostat report, it contains stats since
            # system boot
            if is_first:
                is_first = False
                continue
            #avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            #           0.00    0.00    0.48    0.00    0.00   99.52
            fields = line.split()
            #print "fields = " + str(fields)
            if len(fields) == 6:
                user.append(fields[0])
                nice.append(fields[1])
                system.append(fields[2])
                iowait.append(fields[3])
                steal.append(fields[4])
                idle.append(fields[5])
            else:
                print >>sys.stderr, "parse error: line=\"" + line + "\""

    print "ios avg: user=%3.2lf, nice=%3.2lf, sys=%3.2lf, iowait=%3.2lf, steal=%3.2lf, idle=%3.2lf" % \
        (avg(user), avg(nice), avg(system), avg(iowait), avg(steal), avg(idle))


##############################################################################
def avg(numbers):
    avg = 0
    if len(numbers):
        sum = 0.0
        for n in numbers:
            sum += float(n)
        avg = sum/len(numbers)
    return avg


##############################################################################
def run_bonnie_benchmarks(n_instances):
    global rtcfg
    print "Running bonnie++ benchmark(s)..."
    # kick off n bonnie++ process(es)
    processes = dict()
    dirs = list()
    for n in range(n_instances):
        dir = tempfile.mkdtemp(dir=os.getcwd())
        dirs.append(dir)
        cmd = [ rtcfg['bonnie'], '-d', dir ]
        processes[n] = subprocess.Popen(cmd, shell=False, \
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    # wait for dd jobs to finish
    for n in processes.keys():
        proc = processes[n] # convenience variable
        proc.wait()
        proc_stdout, proc_stderr = proc.communicate()
        if proc.returncode != 0:
            print >>sys.stderr, 'ERROR: bonnie instance ' + str(n) + ' return value = ' + str(proc.returncode)
            print >>sys.stderr, '       result="' + proc_stdout + '"'
        else:
            print 'bonnie instance ' + str(n) + ' results:'
            print proc_stdout + '\n'

    # cleanup temp directories
    for dir in dirs:
        os.rmdir(dir)


##############################################################################
def run_dd_benchmarks(devices):
    global rtcfg
    print "Running dd benchmark(s)..."
    # kick of dd process for each device specified on commandline
    processes = dict()
    for dev in devices:
        cmd = [ rtcfg['dd'], 'if='+dev, 'of=/dev/null', \
              'bs='+rtcfg['dd_bs'], 'count='+rtcfg['dd_count'] ]
        processes[dev] = subprocess.Popen(cmd, shell=False, \
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    # wait for dd jobs to finish
    for dev in processes.keys():
        proc = processes[dev] # convenience variable
        proc.wait()
        proc_stdout, proc_stderr = proc.communicate()
        if proc.returncode != 0:
            print >>sys.stderr, 'ERROR: dd for ' + dev + ' return value = ' + str(proc.returncode)
        else:
            lines = proc_stdout.split('\n')
            if len(lines) != 4:
                print >>sys.stderr, 'ERROR: dd for ' + dev + ' output="' + proc_stdout + '"'
            else:
                print 'dd for ' + dev + ': ' + lines[2]


##############################################################################
# program entry point
##############################################################################
if '__main__' == __name__:
    main()


--IrhDeMKUP4DT/M7F--
