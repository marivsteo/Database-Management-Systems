using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace lab1DBMS
{
    public partial class Form1 : Form
    {

        SqlConnection dbConn;
        SqlDataAdapter daCountries, daParticipants;
        DataSet ds;
        SqlCommandBuilder cb;
        BindingSource bsCountries, bsParticipants;

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            daParticipants.Update(ds, "Participant");
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dbConn = new SqlConnection("Server=DESKTOP-9O46O3J\\SQLEXPRESS;Database=SportsCompetitions;Trusted_Connection=True");
            ds = new DataSet();
            daCountries = new SqlDataAdapter("SELECT * FROM Country", dbConn);
            daParticipants = new SqlDataAdapter("SELECT * FROM Participant", dbConn);
            cb = new SqlCommandBuilder(daParticipants);
            daCountries.Fill(ds, "Country");
            daParticipants.Fill(ds, "Participant");
            DataRelation dr = new DataRelation("FK_Participa_Count",
                ds.Tables["Country"].Columns["CountryID"],
                ds.Tables["Participant"].Columns["CountryID"]);
            ds.Relations.Add(dr);

            //data binding
            bsCountries = new BindingSource();
            bsCountries.DataSource = ds;
            bsCountries.DataMember = "Country";
            bsParticipants = new BindingSource();
            bsParticipants.DataSource = bsCountries;
            bsParticipants.DataMember = "FK_Participa_Count";
            dgvCountries.DataSource = bsCountries;
            dgvParticipants.DataSource = bsParticipants;
        }
    }
}
